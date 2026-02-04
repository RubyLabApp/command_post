module CommandPost
  module Form
    class TextInputComponent < ViewComponent::Base
      attr_reader :name, :value, :type, :placeholder, :disabled, :readonly, :has_error

      def initialize(name:, value: nil, type: :text, placeholder: nil,
                     disabled: false, readonly: false, has_error: false)
        @name = name
        @value = value
        @type = type
        @placeholder = placeholder || name.to_s.humanize
        @disabled = disabled
        @readonly = readonly
        @has_error = has_error
      end

      def theme
        CommandPost.configuration.theme
      end

      def input_classes
        base = "block w-full border px-3 py-2 text-sm shadow-sm outline-none transition duration-150 ease-in-out " \
               "#{theme.border_radius} #{theme.input_border} #{theme.card_bg} #{theme.body_text} #{theme.input_focus}"
        base += " !border-red-400 !focus:border-red-500 !focus:ring-red-500/20" if has_error
        base += " bg-gray-50 cursor-not-allowed" if disabled || readonly
        base
      end

      def call
        tag.input(
          type: type,
          name: name,
          id: name,
          value: value,
          placeholder: placeholder,
          disabled: disabled,
          readonly: readonly,
          class: input_classes
        )
      end
    end
  end
end
