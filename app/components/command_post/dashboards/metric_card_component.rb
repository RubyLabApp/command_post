module CommandPost
  module Dashboards
    class MetricCardComponent < ViewComponent::Base
      def initialize(name:, value:, format: :number)
        @name = name
        @value = value
        @format = format
      end

      def formatted_value
        case @format
        when :currency then helpers.number_to_currency(@value)
        when :percentage then helpers.number_to_percentage(@value, precision: 1)
        else helpers.number_with_delimiter(@value)
        end
      end

      def label
        @name.to_s.humanize
      end
    end
  end
end
