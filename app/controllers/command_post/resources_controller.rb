require "ostruct"

module CommandPost
  class ResourcesController < ApplicationController
    before_action :set_resource_class
    before_action :check_action_allowed, only: %i[new create edit update destroy]

    def index
      scope = apply_scopes(apply_filters(base_scope))
      scope = apply_search(scope)
      scope = apply_sorting(scope)
      scope = apply_preloading(scope)

      @pagy, @records = pagy(scope, limit: CommandPost.configuration.per_page)
      @fields = index_fields
      @current_scope = current_scope_name
    end

    def show
      @record = base_scope.find(params[:id])
      @fields = @resource_class.resolved_fields
    end

    def new
      @record = @resource_class.model.new
      @fields = form_fields
    end

    def edit
      @record = base_scope.find(params[:id])
      @fields = form_fields
    end

    def create
      @record = @resource_class.model.new(resource_params)

      if @record.save
        emit_event(:create, @record)
        redirect_to resource_path(@resource_class.resource_name, @record),
                    notice: "#{@resource_class.model.model_name.human} created."
      else
        @fields = form_fields
        render :new, status: :unprocessable_content
      end
    end

    def update
      @record = base_scope.find(params[:id])

      if @record.update(resource_params)
        emit_event(:update, @record)
        redirect_to resource_path(@resource_class.resource_name, @record),
                    notice: "#{@resource_class.model.model_name.human} updated."
      else
        @fields = form_fields
        render :edit, status: :unprocessable_content
      end
    end

    def destroy
      @record = base_scope.find(params[:id])
      @record.destroy!
      emit_event(:destroy, @record)
      redirect_to resources_path(@resource_class.resource_name),
                  notice: "#{@resource_class.model.model_name.human} deleted."
    end

    def execute_action
      @record = find_record_for_action
      action = @resource_class.defined_actions.find { |a| a[:name].to_s == params[:action_name] }

      return head(:not_found) unless action
      return head(:forbidden) unless action_authorized?(action[:name])

      ActiveRecord::Base.transaction do
        result = action[:block].call(@record)
        emit_event(params[:action_name], @record)

        raise ActiveRecord::Rollback if result == false
      end

      redirect_to resource_path(@resource_class.resource_name, @record), notice: "Action completed"
    rescue StandardError => e
      redirect_to resource_path(@resource_class.resource_name, @record), alert: "Action failed: #{e.message}"
    end

    def execute_bulk_action
      ids = params[:ids] || []
      records = base_scope.where(id: ids)
      action = @resource_class.defined_bulk_actions.find { |a| a[:name].to_s == params[:action_name] }

      return head(:not_found) unless action
      return head(:forbidden) unless action_authorized?(action[:name])

      ActiveRecord::Base.transaction do
        result = action[:block].call(records)

        raise ActiveRecord::Rollback if result == false
      end

      redirect_to resources_path(@resource_class.resource_name), notice: "Bulk action completed"
    rescue StandardError => e
      redirect_to resources_path(@resource_class.resource_name), alert: "Action failed: #{e.message}"
    end

    def autocomplete
      query = params[:q].to_s.strip
      return render json: [] if query.blank?

      display = @resource_class.display_attribute
      conn = @resource_class.model.connection
      table = conn.quote_table_name(@resource_class.model.table_name)
      column = conn.quote_column_name(display)
      like_operator = conn.adapter_name.downcase.include?("postgresql") ? "ILIKE" : "LIKE"

      records = base_scope
        .where("#{table}.#{column} #{like_operator} ?", "%#{query}%")
        .limit(20)
        .map { |r| { id: r.id, label: r.public_send(display) } }

      render json: records
    end

    private

    def base_scope
      scope = @resource_class.model.all

      scope = CommandPost.configuration.tenant_scope_block.call(scope) if CommandPost.configuration.tenant_scope_block

      scope
    end

    def set_resource_class
      @resource_class = ResourceRegistry.find(params[:resource_name])
      head(:not_found) and return unless @resource_class
    end

    def resource_policy
      return @resource_policy if defined?(@resource_policy)

      @resource_policy = (Policy.new(&@resource_class._policy_block) if @resource_class._policy_block)
    end

    def check_action_allowed
      crud_action = case action_name.to_sym
                    when :new, :create then :create
                    when :edit, :update then :update
                    when :destroy then :destroy
                    end

      # Check global action permissions (deny_actions DSL)
      head(:forbidden) and return unless @resource_class.action_allowed?(crud_action)

      # Check policy-based authorization if a policy is defined
      return unless resource_policy

      head(:forbidden) and return unless resource_policy.allowed?(crud_action, command_post_current_user)
    end

    def action_authorized?(action_name)
      return true unless resource_policy

      resource_policy.action_allowed?(action_name, command_post_current_user)
    end

    def index_fields
      if @resource_class.index_field_names
        fields_by_name = @resource_class.resolved_fields.index_by(&:name)
        @resource_class.index_field_names.filter_map { |name| fields_by_name[name] }
      else
        @resource_class.resolved_fields
      end
    end

    def form_fields
      if @resource_class.form_field_names
        @resource_class.resolved_fields.select { |f| f.name.in?(@resource_class.form_field_names) }
      else
        @resource_class.resolved_fields.reject { |f| f.name.in?(%i[id created_at updated_at]) }
      end
    end

    def resource_params
      permitted = form_fields.map do |field|
        field.type == :belongs_to ? field.options[:foreign_key] : field.name
      end
      params.expect(record: [*permitted])
    end

    def apply_filters(scope)
      @resource_class.defined_filters.each do |filter|
        if filter[:type] == :date_range
          from = params.dig(:filters, "#{filter[:name]}_from")
          to = params.dig(:filters, "#{filter[:name]}_to")
          scope = scope.where(filter[:name] => parse_date(from)..) if from.present? && parse_date(from)
          scope = scope.where(filter[:name] => ..parse_date(to)&.end_of_day) if to.present? && parse_date(to)
          next
        end

        value = params.dig(:filters, filter[:name])
        next if value.blank?
        next unless value.is_a?(String)

        value = ActiveModel::Type::Boolean.new.cast(value) if filter[:type] == :boolean

        scope = if filter[:scope]
                  filter[:scope].call(value, scope)
                else
                  scope.where(filter[:name] => value)
                end
      end
      scope
    end

    def parse_date(value)
      return nil if value.blank?

      Date.parse(value)
    rescue ArgumentError, TypeError
      nil
    end

    def current_scope_name
      scope_name = params[:scope]
      defined_scope = @resource_class.defined_scopes.find { |s| s[:name].to_s == scope_name }
      defined_scope ||= @resource_class.defined_scopes.find { |s| s[:default] }
      defined_scope&.dig(:name)&.to_s
    end

    def apply_scopes(scope)
      defined_scope = @resource_class.defined_scopes.find { |s| s[:name].to_s == params[:scope] }
      defined_scope ||= @resource_class.defined_scopes.find { |s| s[:default] }

      return scope unless defined_scope

      scope.merge(defined_scope[:scope])
    end

    def apply_search(scope)
      query = params[:q].to_s.strip
      return scope if query.blank?

      # Check for field:value syntax
      if query.match?(/^\w+:.+$/)
        field, value = query.split(":", 2)
        return apply_field_search(scope, field, value)
      end

      # Default: search all searchable columns
      apply_general_search(scope, query)
    end

    def apply_field_search(scope, field, value)
      return scope unless @resource_class.model.column_names.include?(field)
      return scope unless field_visible?(field.to_sym)

      conn = @resource_class.model.connection
      table = conn.quote_table_name(@resource_class.model.table_name)
      column = conn.quote_column_name(field)
      like_op = conn.adapter_name.downcase.include?("postgresql") ? "ILIKE" : "LIKE"

      # Check for date range syntax (field:from..to)
      if value.include?("..")
        from_str, to_str = value.split("..", 2)
        from_date = parse_date(from_str)
        to_date = parse_date(to_str)

        return scope.where(field => from_date..to_date) if from_date && to_date
        return scope.where("#{table}.#{column} >= ?", from_date) if from_date
        return scope.where("#{table}.#{column} <= ?", to_date) if to_date

        return scope # Both dates invalid, return unfiltered
      end

      scope.where("#{table}.#{column} #{like_op} ?", "%#{value}%")
    end

    def apply_general_search(scope, query)
      columns = visible_searchable_columns
      return scope if columns.empty?

      conn = @resource_class.model.connection
      table = conn.quote_table_name(@resource_class.model.table_name)
      like_operator = conn.adapter_name.downcase.include?("postgresql") ? "ILIKE" : "LIKE"
      conditions = columns.map { |col| "#{table}.#{conn.quote_column_name(col)} #{like_operator} :q" }
      scope.where(conditions.join(" OR "), q: "%#{query}%")
    end

    def visible_searchable_columns
      visible_names = visible_field_names
      @resource_class.searchable_columns.select { |col| visible_names.include?(col) }
    end

    def field_visible?(field_name)
      visible_field_names.include?(field_name)
    end

    def visible_field_names
      @visible_field_names ||= @resource_class.resolved_fields
        .select { |f| f.visible?(command_post_current_user) }
        .map(&:name)
    end

    def apply_sorting(scope)
      sort_col = params[:sort].to_s
      valid_columns = @resource_class.model.column_names
      sort_col = CommandPost.configuration.default_sort.to_s unless valid_columns.include?(sort_col)
      sort_dir = if %w[asc
                       desc].include?(params[:direction].to_s.downcase)
                   params[:direction]
                 else
                   CommandPost.configuration.default_sort_direction
                 end
      scope.order(sort_col => sort_dir)
    end

    def apply_preloading(scope)
      preloads = @resource_class.preload_associations
      preloads.any? ? scope.includes(*preloads) : scope
    end

    def emit_event(action, record)
      event = OpenStruct.new(
        user: command_post_current_user,
        action: action,
        resource: @resource_class.name,
        record_id: record.id,
        changes: record.saved_changes,
        ip_address: request.remote_ip
      )

      # Log to audit log if enabled
      CommandPost::AuditLog.log(event)

      # Call on_action callback if configured
      CommandPost.configuration.on_action_block&.call(event)
    end

    def find_record_for_action
      # Use unscoped for soft delete models to allow finding deleted records
      # This is needed for the restore action to work on soft-deleted records
      if @resource_class.soft_delete?
        @resource_class.model.unscoped.find(params[:id])
      else
        @resource_class.model.find(params[:id])
      end
    end
  end
end
