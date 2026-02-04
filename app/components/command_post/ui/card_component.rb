module CommandPost
  module UI
    class CardComponent < ViewComponent::Base
      renders_one :header
      renders_one :footer

      attr_reader :padding, :shadow

      def initialize(padding: true, shadow: true)
        @padding = padding
        @shadow = shadow
      end

      def theme
        CommandPost.configuration.theme
      end

      def card_classes
        classes = ["overflow-hidden", theme.border_radius, theme.card_bg, "border", theme.card_border]
        classes << theme.card_shadow if shadow
        classes.join(" ")
      end

      def content_classes
        padding ? "p-6" : ""
      end
    end
  end
end
