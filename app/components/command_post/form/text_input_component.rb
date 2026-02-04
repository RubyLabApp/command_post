module CommandPost
  module Form
    class TextInputComponent < ViewComponent::Base
      attr_reader :name, :value, :type, :placeholder, :disabled, :readonly, :has_error, :field, :current_user

      def initialize(name:, value: nil, type: :text, placeholder: nil,
                     disabled: false, readonly: false, has_error: false,
                     field: nil, current_user: nil)
        @name = name
        @value = value
        @type = type
        @placeholder = placeholder || name.to_s.humanize
        @disabled = disabled
        @readonly = readonly
        @has_error = has_error
        @field = field
        @current_user = current_user
      end

      def theme
        CommandPost.configuration.theme
      end

      def effectively_disabled?
        disabled || field_readonly?
      end

      def field_readonly?
        @field&.readonly?(@current_user) || false
      end

      def input_classes
        base = "block w-full border px-3 py-2 text-sm shadow-sm outline-none transition duration-150 ease-in-out " \
               "#{theme.border_radius} #{theme.input_border} #{theme.card_bg} #{theme.body_text} #{theme.input_focus}"
        base += " !border-red-400 !focus:border-red-500 !focus:ring-red-500/20" if has_error
        base += " bg-gray-50 cursor-not-allowed" if effectively_disabled? || readonly
        base
      end

      def call
        tag.input(
          type: type,
          name: name,
          id: name,
          value: value,
          placeholder: placeholder,
          disabled: effectively_disabled?,
          readonly: readonly,
          class: input_classes
        )
      end
    end
  end
end
