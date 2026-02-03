module CommandPost
  class FieldInferrer
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
      jsonb: :json
    }.freeze

    def self.call(model)
      new(model).call
    end

    def initialize(model)
      @model = model
      @belongs_to_map = model.reflect_on_all_associations(:belongs_to)
                             .reject(&:polymorphic?)
                             .each_with_object({}) { |a, m| m[a.foreign_key.to_s] = a }
      @shadowed_columns = model.reflect_on_all_associations(:has_many)
                               .concat(model.reflect_on_all_associations(:has_one))
                               .map { |a| a.name.to_s }.to_set
    end

    def call
      @model.columns.filter_map do |column|
        next if @shadowed_columns.include?(column.name)

        assoc = @belongs_to_map[column.name]
        if assoc
          build_belongs_to_field(assoc)
        else
          build_field(column)
        end
      end
    end

    private

    def build_field(column)
      name = column.name.to_sym

      if enum_column?(name)
        Field.new(name, type: :select, choices: @model.defined_enums[name.to_s].keys)
      else
        Field.new(name, type: TYPE_MAP.fetch(column.type, :text))
      end
    end

    def build_belongs_to_field(association)
      Field.new(
        association.name.to_sym,
        type: :belongs_to,
        association_name: association.name.to_sym,
        association_class: association.klass,
        foreign_key: association.foreign_key.to_sym
      )
    end

    def enum_column?(name)
      @model.defined_enums.key?(name.to_s)
    end
  end
end
