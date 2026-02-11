# frozen_string_literal: true

module CommandPost
  # Infers field configurations from an ActiveRecord model's database schema.
  #
  # This is the core of CommandPost's convention-over-configuration approach.
  # It analyzes the model's columns and associations to automatically generate
  # appropriate field configurations without requiring explicit definitions.
  #
  # The inferrer handles:
  # - Column type to field type mapping
  # - Enum column detection (generates select fields)
  # - belongs_to association detection (generates association fields)
  # - has_many/has_one shadowing (excludes columns named after associations)
  #
  # @example Basic usage
  #   fields = CommandPost::FieldInferrer.call(User)
  #   fields.map(&:name)  #=> [:id, :name, :email, :role, :organization, :created_at, ...]
  #
  # @see CommandPost::Field
  # @see CommandPost::Resource.resolved_fields
  class FieldInferrer
    # Maps database column types to field types.
    # @return [Hash{Symbol => Symbol}]
    TYPE_MAP = {
      string: :text,
      text: :textarea,
      integer: :number,
      float: :number,
      decimal: :number,
      boolean: :boolean,
      date: :date,
      datetime: :datetime,
      time: :time,
      json: :json,
      jsonb: :json,
    }.freeze

    # Infers fields for a model.
    #
    # @param model [Class] An ActiveRecord model class
    # @return [Array<CommandPost::Field>] Inferred field objects
    #
    # @example
    #   fields = CommandPost::FieldInferrer.call(User)
    def self.call(model)
      new(model).call
    end

    # Creates a new FieldInferrer for the given model.
    #
    # @param model [Class] An ActiveRecord model class
    def initialize(model)
      @model = model
      @belongs_to_map = model.reflect_on_all_associations(:belongs_to)
        .reject(&:polymorphic?)
        .index_by { |a| a.foreign_key.to_s }
      @shadowed_columns = model.reflect_on_all_associations(:has_many)
        .concat(model.reflect_on_all_associations(:has_one))
        .to_set { |a| a.name.to_s }
    end

    # Infers fields from the model's columns, associations, attachments,
    # and rich text attributes.
    #
    # Foreign key columns (e.g., organization_id) are replaced with their
    # corresponding belongs_to associations (e.g., organization).
    # Columns named after has_many/has_one associations are excluded.
    # ActiveStorage attachments and ActionText rich text attributes are
    # automatically detected and added as :file, :files, or :rich_text fields.
    #
    # @return [Array<CommandPost::Field>] Inferred field objects
    def call
      fields = @model.columns.filter_map do |column|
        next if @shadowed_columns.include?(column.name)

        assoc = @belongs_to_map[column.name]
        if assoc
          build_belongs_to_field(assoc)
        else
          build_field(column)
        end
      end

      fields.concat(attachment_fields)
      fields.concat(rich_text_fields)
      fields
    end

    private

    # @api private
    # Builds a field from a database column.
    def build_field(column)
      name = column.name.to_sym

      if enum_column?(name)
        Field.new(name, type: :select, choices: @model.defined_enums[name.to_s].keys)
      else
        Field.new(name, type: TYPE_MAP.fetch(column.type, :text))
      end
    end

    # @api private
    # Builds a belongs_to field from an association reflection.
    def build_belongs_to_field(association)
      Field.new(
        association.name.to_sym,
        type: :belongs_to,
        association_name: association.name.to_sym,
        association_class: association.klass,
        foreign_key: association.foreign_key.to_sym
      )
    end

    # @api private
    # Checks if a column is backed by an enum.
    def enum_column?(name)
      @model.defined_enums.key?(name.to_s)
    end

    # @api private
    # Builds fields for ActiveStorage attachments (has_one_attached / has_many_attached).
    def attachment_fields
      return [] unless @model.respond_to?(:attachment_reflections)

      @model.attachment_reflections.map do |name, reflection|
        type = reflection.macro == :has_one_attached ? :file : :files
        Field.new(name.to_sym, type: type)
      end
    end

    # @api private
    # Builds fields for ActionText rich text attributes (has_rich_text).
    def rich_text_fields
      return [] unless @model.respond_to?(:rich_text_association_names)

      @model.rich_text_association_names.map do |assoc_name|
        # ActionText associations are named like "rich_text_body" — strip the prefix
        attr_name = assoc_name.to_s.delete_prefix("rich_text_").to_sym
        Field.new(attr_name, type: :rich_text)
      end
    end
  end
end
