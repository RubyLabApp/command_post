# frozen_string_literal: true

module CommandPost
  module Ui
    # Displays a colored badge/tag for status indicators and labels.
    #
    # @example Basic usage
    #   render CommandPost::Ui::BadgeComponent.new(text: "Active", color: :green)
    #
    # @example With size
    #   render CommandPost::Ui::BadgeComponent.new(text: "New", color: :blue, size: :sm)
    class BadgeComponent < ViewComponent::Base
      # @return [String] The text displayed in the badge
      attr_reader :text

      # @return [Symbol] The color theme (:green, :red, :yellow, :blue, etc.)
      attr_reader :color

      # @return [Symbol] The size (:sm, :md, :lg)
      attr_reader :size

      # Available color themes mapped to Tailwind classes.
      # @return [Hash{Symbol => String}]
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

      # Available sizes mapped to Tailwind classes.
      # @return [Hash{Symbol => String}]
      SIZES = {
        sm: "px-2 py-0.5 text-xs",
        md: "px-2.5 py-0.5 text-sm",
        lg: "px-3 py-1 text-sm",
      }.freeze

      # @param text [String] The badge text
      # @param color [Symbol] Color theme (default: :gray)
      # @param size [Symbol] Size variant (default: :md)
      def initialize(text:, color: :gray, size: :md)
        @text = text
        @color = color.to_sym
        @size = size.to_sym
      end

      # @api private
      # @return [String] CSS color classes for badge
      def color_classes
        CommandPost.configuration.badge_colors[@color] || COLORS[@color] || COLORS[:gray]
      end

      # @api private
      # @return [String] CSS size classes for badge
      def size_classes
        SIZES[@size] || SIZES[:md]
      end

      # Renders the badge span.
      # @return [String] HTML content
      def call
        tag.span(text, class: "inline-flex items-center font-medium rounded-full #{color_classes} #{size_classes}")
      end
    end
  end
end
