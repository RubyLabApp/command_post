module CommandPost
  module Form
    class DatePickerComponent < ViewComponent::Base
      attr_reader :name, :value, :type, :min, :max, :disabled, :has_error

      TYPES = %i[date datetime datetime_local time].freeze

      def initialize(name:, value: nil, type: :datetime_local, min: nil, max: nil,
                     disabled: false, has_error: false)
        @name = name
        @value = value
        @type = type.to_sym
        @min = min
        @max = max
        @disabled = disabled
        @has_error = has_error
      end

      def theme
        CommandPost.configuration.theme
      end

      def input_type
        case @type
        when :datetime_local then "datetime-local"
        when :datetime then "datetime-local"
        else @type.to_s
        end
      end

      def input_classes
        base = "block w-full border px-3 py-2 text-sm shadow-sm outline-none transition duration-150 ease-in-out " \
               "#{theme.border_radius} #{theme.input_border} #{theme.card_bg} #{theme.body_text} #{theme.input_focus}"
        base += " !border-red-400 !focus:border-red-500 !focus:ring-red-500/20" if has_error
        base += " bg-gray-50 cursor-not-allowed" if disabled
        base
      end

      def formatted_value
        return nil unless value

        case @type
        when :date
          value.respond_to?(:strftime) ? value.strftime("%Y-%m-%d") : value
        when :datetime, :datetime_local
          value.respond_to?(:strftime) ? value.strftime("%Y-%m-%dT%H:%M") : value
        when :time
          value.respond_to?(:strftime) ? value.strftime("%H:%M") : value
        else
          value
        end
      end

      def call
        tag.input(
          type: input_type,
          name: name,
          id: name,
          value: formatted_value,
          min: min,
          max: max,
          disabled: disabled,
          class: input_classes
        )
      end
    end
  end
end
