module CommandPost
  module Filters
    class BarComponent < ViewComponent::Base
      renders_many :filters

      attr_reader :form_url, :scope, :query, :active_count

      def initialize(form_url:, scope: nil, query: nil, active_count: 0)
        @form_url = form_url
        @scope = scope
        @query = query
        @active_count = active_count
      end

      def theme
        CommandPost.configuration.theme
      end

      def has_active_filters?
        active_count.positive?
      end

      def trigger_classes
        "inline-flex items-center gap-2 px-4 cursor-pointer select-none text-sm font-medium " \
          "#{theme.border_radius} border shadow-sm transition duration-150 " \
          "#{theme.label_text} #{theme.card_border} #{theme.card_bg} py-2.5 hover:bg-gray-50"
      end

      def dropdown_classes
        "absolute right-0 top-full mt-2 w-72 border z-20 #{theme.border_radius} " \
          "#{theme.card_border} #{theme.card_bg} #{theme.card_shadow}-lg"
      end
    end
  end
end
