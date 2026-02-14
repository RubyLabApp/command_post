# frozen_string_literal: true

module IronAdmin
  # Dashboard components for rendering metrics, charts, and activity feeds.
  module Dashboards
    # Renders a chart on the dashboard.
    class ChartComponent < ViewComponent::Base
      # @return [String] Chart title
      attr_reader :title

      # @return [Symbol] Chart type (:line, :bar, :pie, :doughnut)
      attr_reader :type

      # @return [Array] Chart data
      attr_reader :data

      # @return [Array] Chart labels
      attr_reader :labels

      # @return [Integer] Chart height in pixels
      attr_reader :height

      # Supported chart types.
      # @return [Array<Symbol>]
      TYPES = %i[line bar pie doughnut].freeze

      # @param title [String] Chart title
      # @param type [Symbol] Chart type (default: :line)
      # @param data [Array] Chart data
      # @param labels [Array] Chart labels
      # @param colors [Array<String>, nil] Per-chart color palette (overrides theme)
      # @param height [Integer] Height (default: 300)
      def initialize(title:, type: :line, data: [], labels: [], colors: nil, height: 300)
        @title = title
        @type = type.to_sym
        @data = data
        @labels = labels
        @colors = colors
        @height = height
      end

      # @api private
      # @return [IronAdmin::Configuration::Theme] Theme configuration
      def theme
        IronAdmin.configuration.theme
      end

      # @api private
      # @return [String] Unique chart element ID
      def chart_id
        "chart-#{object_id}"
      end

      # @api private
      # @return [String] Chart.js configuration JSON
      def chart_config
        colors = resolved_colors
        border = resolved_border_color
        {
          type: type,
          data: {
            labels: labels,
            datasets: [{
              data: data,
              borderColor: border,
              backgroundColor: type == :line ? line_fill_color(border) : colors,
              fill: type == :line,
              tension: 0.3,
            }],
          },
          options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
              legend: { display: %i[pie doughnut].include?(type) },
            },
          },
        }.to_json
      end

      # Resolves chart colors with priority: per-chart > theme > default.
      # @api private
      # @return [Array<String>] Resolved chart color palette
      def chart_colors
        resolved_colors
      end

      private

      # @return [Array<String>] Color palette resolved from per-chart, theme, or default
      def resolved_colors
        @colors || theme.chart_colors
      end

      # @return [String] Border color resolved from per-chart first color or theme
      def resolved_border_color
        @colors&.first || theme.chart_border_color
      end

      # Converts a CSS color to a semi-transparent version for line chart fill.
      # Supports hex (#rrggbb), rgb(), and rgba() formats.
      # @param color [String] CSS color value
      # @return [String] Color with 0.1 opacity
      def line_fill_color(color)
        if color.start_with?("#")
          "#{color}1A"
        elsif color.start_with?("rgba")
          color.sub(/[\d.]+\)$/, "0.1)")
        elsif color.start_with?("rgb")
          color.sub("rgb(", "rgba(").sub(")", ", 0.1)")
        else
          color
        end
      end
    end
  end
end
