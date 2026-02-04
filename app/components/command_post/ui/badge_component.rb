module CommandPost
  module UI
    class BadgeComponent < ViewComponent::Base
      attr_reader :text, :color, :size

      COLORS = {
        green: "bg-green-100 text-green-800",
        red: "bg-red-100 text-red-800",
        yellow: "bg-yellow-100 text-yellow-800",
        blue: "bg-blue-100 text-blue-800",
        indigo: "bg-indigo-100 text-indigo-800",
        purple: "bg-purple-100 text-purple-800",
        pink: "bg-pink-100 text-pink-800",
        orange: "bg-orange-100 text-orange-800",
        teal: "bg-teal-100 text-teal-800",
        gray: "bg-gray-100 text-gray-800",
      }.freeze

      SIZES = {
        sm: "px-2 py-0.5 text-xs",
        md: "px-2.5 py-0.5 text-sm",
        lg: "px-3 py-1 text-sm",
      }.freeze

      def initialize(text:, color: :gray, size: :md)
        @text = text
        @color = color.to_sym
        @size = size.to_sym
      end

      def color_classes
        CommandPost.configuration.badge_colors[@color] || COLORS[@color] || COLORS[:gray]
      end

      def size_classes
        SIZES[@size] || SIZES[:md]
      end

      def call
        tag.span(text, class: "inline-flex items-center font-medium rounded-full #{color_classes} #{size_classes}")
      end
    end
  end
end
