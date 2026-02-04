module CommandPost
  module Dashboards
    class ChartComponent < ViewComponent::Base
      attr_reader :title, :type, :data, :labels, :height

      TYPES = %i[line bar pie doughnut].freeze

      def initialize(title:, type: :line, data: [], labels: [], height: 300)
        @title = title
        @type = type.to_sym
        @data = data
        @labels = labels
        @height = height
      end

      def theme
        CommandPost.configuration.theme
      end

      def chart_id
        "chart-#{object_id}"
      end

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
