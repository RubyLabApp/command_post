module CommandPost
  module Form
    class CheckboxComponent < ViewComponent::Base
      attr_reader :name, :checked, :label, :disabled

      def initialize(name:, checked: false, label: nil, disabled: false)
        @name = name
        @checked = checked
        @label = label
        @disabled = disabled
      end

      def theme
        CommandPost.configuration.theme
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
