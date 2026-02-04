module CommandPost
  class Resource
    class_attribute :field_overrides, default: {}
    class_attribute :_searchable_columns, default: nil
    class_attribute :defined_filters, default: []
    class_attribute :defined_scopes, default: []
    class_attribute :defined_actions, default: []
    class_attribute :defined_bulk_actions, default: []
    class_attribute :index_field_names, default: nil
    class_attribute :form_field_names, default: nil
    class_attribute :menu_options, default: {}
    class_attribute :component_overrides, default: {}
    class_attribute :_policy_block, default: nil
    class_attribute :export_formats, default: %i[csv json]
    class_attribute :export_field_names, default: nil
    class_attribute :denied_crud_actions, default: []
    class_attribute :defined_associations, default: {}
    class_attribute :model_class_override, default: nil

    class << self
      def inherited(subclass)
        super
        return if subclass.name.nil?

        begin
          CommandPost::ResourceRegistry.register(subclass)
        rescue NameError
        end
      end

      def model
        return model_class_override if model_class_override

        name.sub(/Resource\z/, "").constantize
      end

      def field(name, **options)
        self.field_overrides = field_overrides.merge(name => options)
      end

      def searchable(*columns)
        self._searchable_columns = columns
      end

      def searchable_columns
        return _searchable_columns if _searchable_columns

        model.columns.select { |c| c.type.in?(%i[string text]) }
          .map { |c| c.name.to_sym }
          .reject { |name| name.to_s.end_with?("_digest") }
      end

      def filter(name, **options)
        self.defined_filters = defined_filters + [{ name: name, **options }]
      end

      def remove_filter(name)
        self.defined_filters = defined_filters.reject { |f| f[:name] == name }
      end

      def scope(name, lambda, default: false)
        self.defined_scopes = defined_scopes + [{ name: name, scope: lambda, default: default }]
      end

      def action(name, **options, &block)
        self.defined_actions = defined_actions + [{ name: name, block: block, **options }]
      end

      def bulk_action(name, **options, &block)
        self.defined_bulk_actions = defined_bulk_actions + [{ name: name, block: block, **options }]
      end

      def index_fields(*fields)
        self.index_field_names = fields
      end

      def form_fields(*fields)
        self.form_field_names = fields
      end

      def menu(**options)
        self.menu_options = options
      end

      def component(name, klass)
        self.component_overrides = component_overrides.merge(name => klass)
      end

      def policy(&block)
        self._policy_block = block
      end

      def deny_actions(*actions)
        self.denied_crud_actions = actions.map(&:to_sym)
      end

      def action_allowed?(action_name)
        denied_crud_actions.exclude?(action_name.to_sym)
      end

      def exports(*formats)
        self.export_formats = formats
      end

      def export_fields(*fields)
        self.export_field_names = fields
      end

      def belongs_to(name, **options)
        self.defined_associations = defined_associations.merge(name => { kind: :belongs_to, **options })
      end

      def has_many(name, **options)
        self.defined_associations = defined_associations.merge(name => { kind: :has_many, **options })
      end

      def has_one(name, **options)
        self.defined_associations = defined_associations.merge(name => { kind: :has_one, **options })
      end

      def resolved_fields
        inferred = FieldInferrer.call(model)

        inferred.map do |field|
          overrides = field_overrides[field.name] || {}
          assoc_overrides = defined_associations[field.name] || {}
          merged = assoc_overrides.except(:kind).merge(overrides)

          if merged.any?
            Field.new(field.name, type: field.type, **field.options, **merged)
          else
            field
          end
        end
      end

      def preload_associations
        @preload_associations || infer_preload_associations
      end

      def preload(*associations)
        @preload_associations = associations
      end

      def has_many_associations
        defined_associations.filter_map do |assoc_name, config|
          next unless config[:kind] == :has_many

          reflection = model.reflect_on_association(assoc_name)
          next unless reflection

          resource = ResourceRegistry.find(reflection.klass.model_name.plural)
          next unless resource

          { name: assoc_name, reflection: reflection, resource: resource, **config.except(:kind) }
        end
      end

      def resource_name
        model.model_name.plural
      end

      def label
        model.model_name.human.pluralize
      end

      def display_attribute
        ApplicationHelper::DISPLAY_METHODS.find do |method|
          model.column_names.include?(method.to_s)
        end || :id
      end

      def soft_delete?
        model.column_names.include?(soft_delete_column)
      end

      def soft_delete_column
        "deleted_at"
      end

      def register_soft_delete_features
        return unless soft_delete?

        # Capture the column name for use in lambdas
        column = soft_delete_column
        column_sym = column.to_sym

        # Register with_deleted scope
        scope :with_deleted, -> { unscope(where: column_sym) }

        # Register only_deleted scope
        scope :only_deleted, -> { unscope(where: column_sym).where.not(column => nil) }

        # Register restore action
        action :restore, icon: "arrow-path" do |record|
          record.update(column => nil)
        end
      end

      private

      def infer_preload_associations
        resolved_fields.select { |f| f.type == :belongs_to }.map(&:name)
      end
    end
  end
end
