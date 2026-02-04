module CommandPost
  module Form
    class TextareaComponent < ViewComponent::Base
      attr_reader :name, :value, :rows, :placeholder, :disabled, :readonly, :has_error

      def initialize(name:, value: nil, rows: 4, placeholder: nil,
                     disabled: false, readonly: false, has_error: false)
        @name = name
        @value = value
        @rows = rows
        @placeholder = placeholder || name.to_s.humanize
        @disabled = disabled
        @readonly = readonly
        @has_error = has_error
      end

      def theme
        CommandPost.configuration.theme
      end

      def textarea_classes
        base = "block w-full border px-3 py-2 text-sm shadow-sm outline-none transition duration-150 ease-in-out " \
               "resize-y #{theme.border_radius} #{theme.input_border} #{theme.card_bg} #{theme.body_text} #{theme.input_focus}"
        base += " !border-red-400 !focus:border-red-500 !focus:ring-red-500/20" if has_error
        base += " bg-gray-50 cursor-not-allowed" if disabled || readonly
        base
      end

      def call
        tag.textarea(
          value,
          name: name,
          id: name,
          rows: rows,
          placeholder: placeholder,
          disabled: disabled,
          readonly: readonly,
          class: textarea_classes
        )
      end
    end
  end
end
