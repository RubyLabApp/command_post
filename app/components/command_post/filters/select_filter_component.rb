module CommandPost
  module Filters
    class SelectFilterComponent < ViewComponent::Base
      attr_reader :name, :label, :options, :selected

      def initialize(name:, options:, label: nil, selected: nil)
        @name = name
        @label = label || name.to_s.humanize
        @options = options
        @selected = selected
      end

      def theme
        CommandPost.configuration.theme
      end

      def field_name
        "filters[#{name}]"
      end

      def label_classes
        "block text-xs font-semibold uppercase tracking-wider #{theme.muted_text}"
      end

      def select_classes
        "block w-full appearance-none border px-3 py-2 text-sm shadow-sm outline-none " \
          "transition duration-150 ease-in-out #{theme.border_radius} #{theme.input_border} " \
          "#{theme.card_bg} #{theme.body_text} #{theme.input_focus}"
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
