module CommandPost
  module Layout
    class SidebarComponent < ViewComponent::Base
      include CommandPost::ThemeHelper

      def grouped_resources
        CommandPost::ResourceRegistry.grouped
      end

      def title
        CommandPost.configuration.title
      end

      def logo
        CommandPost.configuration.logo
      end
    end
  end
end
