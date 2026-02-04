module CommandPost
  module Resources
    class ShowFieldComponent < ViewComponent::Base
      attr_reader :field, :record, :current_user

      def initialize(field:, record:, current_user: nil)
        @field = field
        @record = record
        @current_user = current_user
      end

      def render?
        field.visible?(@current_user)
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
