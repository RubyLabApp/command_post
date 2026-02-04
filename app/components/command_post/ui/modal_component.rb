module CommandPost
  module UI
    class ModalComponent < ViewComponent::Base
      renders_one :title
      renders_one :footer

      attr_reader :size, :dismissible

      SIZES = {
        sm: "max-w-md",
        md: "max-w-lg",
        lg: "max-w-2xl",
        xl: "max-w-4xl",
        full: "max-w-full mx-4",
      }.freeze

      def initialize(size: :md, dismissible: true)
        @size = size.to_sym
        @dismissible = dismissible
      end

      def theme
        CommandPost.configuration.theme
      end

      def size_classes
        SIZES[@size] || SIZES[:md]
      end

      def modal_classes
        "relative #{theme.card_bg} #{theme.border_radius} #{theme.card_shadow}-xl w-full #{size_classes}"
      end
    end
  end
end
