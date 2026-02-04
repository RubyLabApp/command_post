module CommandPost
  module Form
    class SelectComponent < ViewComponent::Base
      attr_reader :name, :options, :selected, :include_blank, :disabled, :has_error

      def initialize(name:, options:, selected: nil, include_blank: nil,
                     disabled: false, has_error: false)
        @name = name
        @options = options
        @selected = selected
        @include_blank = include_blank
        @disabled = disabled
        @has_error = has_error
      end

      def theme
        CommandPost.configuration.theme
      end

      def select_classes
        base = "block w-full appearance-none border px-3 py-2 text-sm shadow-sm outline-none " \
               "transition duration-150 ease-in-out #{theme.border_radius} #{theme.input_border} " \
               "#{theme.card_bg} #{theme.body_text} #{theme.input_focus}"
        base += " !border-red-400 !focus:border-red-500 !focus:ring-red-500/20" if has_error
        base += " bg-gray-50 cursor-not-allowed" if disabled
        base
      end

      def chevron_style
        "background-image: url(\"data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' fill='none' " \
          "viewBox='0 0 20 20'%3e%3cpath stroke='%236b7280' stroke-linecap='round' stroke-linejoin='round' " \
          "stroke-width='1.5' d='M6 8l4 4 4-4'/%3e%3c/svg%3e\"); background-position: right 0.5rem center; " \
          "background-repeat: no-repeat; background-size: 1.5em 1.5em; padding-right: 2.5rem;"
      end
    end
  end
end
