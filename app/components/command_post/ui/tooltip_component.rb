module CommandPost
  module UI
    class TooltipComponent < ViewComponent::Base
      attr_reader :text, :position

      POSITIONS = {
        top: "bottom-full left-1/2 -translate-x-1/2 mb-2",
        bottom: "top-full left-1/2 -translate-x-1/2 mt-2",
        left: "right-full top-1/2 -translate-y-1/2 mr-2",
        right: "left-full top-1/2 -translate-y-1/2 ml-2",
      }.freeze

      def initialize(text:, position: :top)
        @text = text
        @position = position.to_sym
      end

      def position_classes
        POSITIONS[@position] || POSITIONS[:top]
      end

      def tooltip_classes
        "absolute #{position_classes} px-2 py-1 text-xs font-medium text-white bg-gray-900 " \
          "rounded whitespace-nowrap opacity-0 invisible group-hover:opacity-100 group-hover:visible " \
          "transition-all duration-150 z-50"
      end
    end
  end
end
