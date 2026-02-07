# frozen_string_literal: true

module CommandPost
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
      # @param height [Integer] Height (default: 300)
      def initialize(title:, type: :line, data: [], labels: [], height: 300)
        @title = title
        @type = type.to_sym
        @data = data
        @labels = labels
        @height = height
      end

      # @api private
      # @return [CommandPost::Configuration::Theme] Theme configuration
      def theme
        CommandPost.configuration.theme
      end

      # @api private
      # @return [String] Unique chart element ID
      def chart_id
        "chart-#{object_id}"
      end

      # @api private
      # @return [String] Chart.js configuration JSON
      def chart_config
        {
          type: type,
          data: {
            labels: labels,
            datasets: [{
              data: data,
              borderColor: "rgb(99, 102, 241)",
              backgroundColor: type == :line ? "rgba(99, 102, 241, 0.1)" : chart_colors,
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

      # @api private
      # @return [Array<String>] Default chart color palette
      def chart_colors
        %w[
          rgba(99,102,241,0.8)
          rgba(59,130,246,0.8)
          rgba(16,185,129,0.8)
          rgba(245,158,11,0.8)
          rgba(239,68,68,0.8)
          rgba(139,92,246,0.8)
        ]
      end
    end
  end
end
