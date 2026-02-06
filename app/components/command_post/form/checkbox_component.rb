module CommandPost
  module Form
    class CheckboxComponent < ViewComponent::Base
      include Concerns::FormInputBehavior

      attr_reader :name, :checked, :label

      def initialize(name:, checked: false, label: nil, disabled: false, field: nil, current_user: nil)
        @name = name
        @checked = checked
        @label = label
        @disabled = disabled
        @field = field
        @current_user = current_user
      end

      def checkbox_classes
        "h-4 w-4 rounded border-gray-300 text-indigo-600 #{theme.checkbox_checked} " \
          "transition duration-150 ease-in-out"
      end

      def label_classes
        "text-sm #{theme.body_text}"
      end
    end
  end
end
