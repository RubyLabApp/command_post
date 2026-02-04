module CommandPost
  module Dashboards
    class ActivityFeedComponent < ViewComponent::Base
      renders_many :items, "ItemComponent"

      attr_reader :title

      def initialize(title: "Recent Activity")
        @title = title
      end

      def theme
        CommandPost.configuration.theme
      end

      def render?
        items.any?
      end

      class ItemComponent < ViewComponent::Base
        attr_reader :icon, :icon_color, :description, :timestamp, :href

        COLORS = {
          green: "bg-green-100 text-green-600",
          red: "bg-red-100 text-red-600",
          blue: "bg-blue-100 text-blue-600",
          yellow: "bg-yellow-100 text-yellow-600",
          gray: "bg-gray-100 text-gray-600",
        }.freeze

        def initialize(description:, timestamp:, icon: "circle-stack", icon_color: :blue, href: nil)
          @description = description
          @timestamp = timestamp
          @icon = icon
          @icon_color = icon_color.to_sym
          @href = href
        end

        def theme
          CommandPost.configuration.theme
        end

        def icon_classes
          COLORS[@icon_color] || COLORS[:gray]
        end

        def formatted_timestamp
          if timestamp.respond_to?(:strftime)
            timestamp.strftime("%b %d, %H:%M")
          else
            timestamp
          end
        end
      end
    end
  end
end
