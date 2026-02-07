# frozen_string_literal: true

module CommandPost
  module Dashboards
    # Renders a metric card with name and formatted value.
    class MetricCardComponent < ViewComponent::Base
      # @param name [String, Symbol] Metric name
      # @param value [Numeric] Metric value
      # @param format [Symbol] Format (:number, :currency, :percentage)
      def initialize(name:, value:, format: :number)
        @name = name
        @value = value
        @format = format
      end

      # @api private
      # @return [String] Value formatted according to format option
      def formatted_value
        case @format
        when :currency then helpers.number_to_currency(@value)
        when :percentage then helpers.number_to_percentage(@value, precision: 1)
        else helpers.number_with_delimiter(@value)
        end
      end

      # @api private
      # @return [String] Humanized metric label
      def label
        @name.to_s.humanize
      end
    end
  end
end
