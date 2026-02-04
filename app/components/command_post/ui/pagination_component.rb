module CommandPost
  module UI
    class PaginationComponent < ViewComponent::Base
      include Pagy::Frontend

      attr_reader :pagy_obj

      def initialize(pagy:)
        @pagy_obj = pagy
      end

      def theme
        CommandPost.configuration.theme
      end

      def render?
        pagy_obj.pages > 1
      end

      def page_link_classes(active: false)
        base = "px-3 py-2 text-sm font-medium border transition-colors duration-150"
        if active
          "#{base} bg-indigo-50 border-indigo-500 text-indigo-600 z-10"
        else
          "#{base} #{theme.card_bg} #{theme.card_border} #{theme.body_text} hover:bg-gray-50"
        end
      end

      def nav_link_classes(disabled: false)
        base = "relative inline-flex items-center px-3 py-2 text-sm font-medium border transition-colors duration-150"
        if disabled
          "#{base} #{theme.card_bg} #{theme.card_border} text-gray-300 cursor-not-allowed"
        else
          "#{base} #{theme.card_bg} #{theme.card_border} #{theme.body_text} hover:bg-gray-50"
        end
      end
    end
  end
end
