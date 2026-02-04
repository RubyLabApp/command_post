module CommandPost
  module Dashboards
    class StatsGridComponent < ViewComponent::Base
      renders_many :stats, "StatComponent"

      attr_reader :columns

      def initialize(columns: 4)
        @columns = columns
      end

      def grid_classes
        case columns
        when 2 then "grid-cols-1 sm:grid-cols-2"
        when 3 then "grid-cols-1 sm:grid-cols-2 lg:grid-cols-3"
        when 4 then "grid-cols-1 sm:grid-cols-2 lg:grid-cols-4"
        else "grid-cols-1 sm:grid-cols-2 lg:grid-cols-4"
        end
      end

      class StatComponent < ViewComponent::Base
        attr_reader :label, :value, :change, :change_type, :icon

        def initialize(label:, value:, change: nil, change_type: :neutral, icon: nil)
          @label = label
          @value = value
          @change = change
          @change_type = change_type.to_sym
          @icon = icon
        end

        def theme
          CommandPost.configuration.theme
        end

        def change_classes
          case change_type
          when :positive then "text-green-600"
          when :negative then "text-red-600"
          else theme.muted_text
          end
        end

        def change_icon
          case change_type
          when :positive then "arrow-trending-up"
          when :negative then "arrow-trending-down"
          end
        end
      end
    end
  end
end
