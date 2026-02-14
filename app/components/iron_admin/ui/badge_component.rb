# frozen_string_literal: true

module IronAdmin
  module Ui
    # Displays a colored badge/tag for status indicators and labels.
    #
    # @example Basic usage
    #   render IronAdmin::Ui::BadgeComponent.new(text: "Active", color: :green)
    #
    # @example With size
    #   render IronAdmin::Ui::BadgeComponent.new(text: "New", color: :blue, size: :sm)
    class BadgeComponent < ViewComponent::Base
      # @return [String] The text displayed in the badge
      attr_reader :text

      # @return [Symbol] The color theme (:green, :red, :yellow, :blue, etc.)
      attr_reader :color

      # @return [Symbol] The size (:sm, :md, :lg)
      attr_reader :size

      # @api private
      # @return [IronAdmin::Configuration::Theme] Theme configuration
      def self.theme
        IronAdmin.configuration.theme
      end

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
        colors = self.class.theme.badge.colors
        IronAdmin.configuration.badge_colors[@color] || colors[@color] || colors[:gray]
      end

      # @api private
      # @return [String] CSS size classes for badge
      def size_classes
        sizes = self.class.theme.badge.sizes
        sizes[@size] || sizes[:md]
      end

      # Renders the badge span.
      # @return [String] HTML content
      def call
        tag.span(text, class: "#{self.class.theme.badge.base} #{color_classes} #{size_classes}")
      end
    end
  end
end
