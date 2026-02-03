module CommandPost
  class ResourcesController < ApplicationController
    before_action :set_resource_class
    before_action :check_action_allowed, only: %i[new create edit update destroy]

    def index
      scope = apply_scopes(apply_filters(@resource_class.model.all))
      scope = apply_search(scope)
      scope = apply_sorting(scope)

      @pagy, @records = pagy(scope, limit: CommandPost.configuration.per_page)
      @fields = index_fields
      @current_scope = current_scope_name
    end

    def show
      @record = @resource_class.model.find(params[:id])
      @fields = @resource_class.resolved_fields
    end

    def new
      @record = @resource_class.model.new
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
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @record = @resource_class.model.find(params[:id])
      @fields = form_fields
    end

    def update
      @record = @resource_class.model.find(params[:id])

      if @record.update(resource_params)
        emit_event(:update, @record)
        redirect_to resource_path(@resource_class.resource_name, @record),
                    notice: "#{@resource_class.model.model_name.human} updated."
      else
        @fields = form_fields
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @record = @resource_class.model.find(params[:id])
      @record.destroy!
      emit_event(:destroy, @record)
      redirect_to resources_path(@resource_class.resource_name),
                  notice: "#{@resource_class.model.model_name.human} deleted."
    end

    def execute_action
      @record = @resource_class.model.find(params[:id])
      action = @resource_class.defined_actions.find { |a| a[:name].to_s == params[:action_name] }

      if action
        action[:block].call(@record)
        emit_event(params[:action_name], @record)
        redirect_to resource_path(@resource_class.resource_name, @record), notice: "Action executed."
      else
        redirect_to resource_path(@resource_class.resource_name, @record), alert: "Action not found."
      end
    end

    def execute_bulk_action
      ids = params[:ids] || []
      records = @resource_class.model.where(id: ids)
      action = @resource_class.defined_bulk_actions.find { |a| a[:name].to_s == params[:action_name] }

      if action
        action[:block].call(records)
        redirect_to resources_path(@resource_class.resource_name), notice: "Bulk action executed."
      else
        redirect_to resources_path(@resource_class.resource_name), alert: "Action not found."
      end
    end

    private

    def set_resource_class
      @resource_class = ResourceRegistry.find(params[:resource_name])
      head(:not_found) and return unless @resource_class
    end

    def check_action_allowed
      crud_action = case action_name.to_sym
      when :new, :create then :create
      when :edit, :update then :update
      when :destroy then :destroy
      end
      head(:forbidden) and return unless @resource_class.action_allowed?(crud_action)
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
        @resource_class.resolved_fields.reject { |f| f.name.in?([ :id, :created_at, :updated_at ]) }
      end
    end

    def resource_params
      permitted = form_fields.map do |field|
        field.type == :belongs_to ? field.options[:foreign_key] : field.name
      end
      params.require(:record).permit(*permitted)
    end

    def apply_filters(scope)
      @resource_class.defined_filters.each do |filter|
        if filter[:type] == :date_range
          from = params.dig(:filters, "#{filter[:name]}_from")
          to = params.dig(:filters, "#{filter[:name]}_to")
          scope = scope.where(filter[:name] => from..) if from.present?
          scope = scope.where(filter[:name] => ..to.to_date.end_of_day) if to.present?
          next
        end

        value = params.dig(:filters, filter[:name])
        next if value.blank?

        if filter[:type] == :boolean
          value = ActiveModel::Type::Boolean.new.cast(value)
        end

        scope = if filter[:scope]
                  filter[:scope].call(value, scope)
        else
                  scope.where(filter[:name] => value)
        end
      end
      scope
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
      query = params[:q]
      return scope if query.blank?

      columns = @resource_class.searchable_columns
      conn = @resource_class.model.connection
      table = conn.quote_table_name(@resource_class.model.table_name)
      conditions = columns.map { |col| "#{table}.#{conn.quote_column_name(col)} ILIKE :q" }
      scope.where(conditions.join(" OR "), q: "%#{query}%")
    end

    def apply_sorting(scope)
      sort_col = params[:sort].to_s
      valid_columns = @resource_class.model.column_names
      sort_col = CommandPost.configuration.default_sort.to_s unless valid_columns.include?(sort_col)
      sort_dir = %w[asc desc].include?(params[:direction].to_s.downcase) ? params[:direction] : CommandPost.configuration.default_sort_direction
      scope.order(sort_col => sort_dir)
    end

    def emit_event(action, record)
      return unless CommandPost.configuration.on_action_block

      event = OpenStruct.new(
        user: command_post_current_user,
        action: action,
        resource: @resource_class.name,
        record_id: record.id,
        changes: record.saved_changes,
        ip_address: request.remote_ip
      )
      CommandPost.configuration.on_action_block.call(event)
    end
  end
end
