# frozen_string_literal: true

module IronAdmin
  module Ui
    # Renders a tooltip that appears on hover.
    #
    # @example Basic tooltip
    #   render IronAdmin::Ui::TooltipComponent.new(text: "More info") do
    #     heroicon("information-circle")
    #   end
    class TooltipComponent < ViewComponent::Base
      # @return [String] Tooltip text
      attr_reader :text

      # @return [Symbol] Position (:top, :bottom, :left, :right)
      attr_reader :position

      # @api private
      # @return [IronAdmin::Configuration::Theme] Theme configuration
      def self.theme
        IronAdmin.configuration.theme
      end

      # @param text [String] Tooltip text
      # @param position [Symbol] Position (default: :top)
      def initialize(text:, position: :top)
        @text = text
        @position = position.to_sym
      end

      # @api private
      # @return [String] CSS classes for tooltip position
      def position_classes
        positions = self.class.theme.tooltip.positions
        positions[@position] || positions[:top]
      end

      # @api private
      # @return [String] CSS classes for tooltip container
      def tooltip_classes
        "#{self.class.theme.tooltip.base} #{position_classes}"
      end
    end
  end
end
