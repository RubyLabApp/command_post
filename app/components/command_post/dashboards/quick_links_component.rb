module CommandPost
  module Dashboards
    class QuickLinksComponent < ViewComponent::Base
      renders_many :links, "LinkComponent"

      attr_reader :title

      def initialize(title: "Quick Links")
        @title = title
      end

      def theme
        CommandPost.configuration.theme
      end

      def render?
        links.any?
      end

      class LinkComponent < ViewComponent::Base
        attr_reader :label, :href, :icon, :description

        def initialize(label:, href:, icon: nil, description: nil)
          @label = label
          @href = href
          @icon = icon
          @description = description
        end

        def theme
          CommandPost.configuration.theme
        end
      end
    end
  end
end
