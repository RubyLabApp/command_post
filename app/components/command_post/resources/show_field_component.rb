module CommandPost
  module Resources
    class ShowFieldComponent < ViewComponent::Base
      attr_reader :field, :record

      def initialize(field:, record:)
        @field = field
        @record = record
      end

      def theme
        CommandPost.configuration.theme
      end

      def label
        field.name.to_s.humanize
      end

      def value
        helpers.display_field_value(record, field)
      end
    end
  end
end
