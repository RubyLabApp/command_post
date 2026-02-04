module CommandPost
  module Filters
    class DateRangeComponent < ViewComponent::Base
      attr_reader :name, :label, :from_value, :to_value

      def initialize(name:, label: nil, from_value: nil, to_value: nil)
        @name = name
        @label = label || name.to_s.humanize
        @from_value = from_value
        @to_value = to_value
      end

      def theme
        CommandPost.configuration.theme
      end

      def from_field_name
        "filters[#{name}_from]"
      end

      def to_field_name
        "filters[#{name}_to]"
      end

      def label_classes
        "block text-xs font-semibold uppercase tracking-wider #{theme.muted_text}"
      end

      def input_classes
        "block w-full border px-3 py-2 text-sm shadow-sm outline-none " \
          "transition duration-150 ease-in-out #{theme.border_radius} #{theme.input_border} " \
          "#{theme.card_bg} #{theme.body_text} #{theme.input_focus}"
      end
    end
  end
end
