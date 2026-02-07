# frozen_string_literal: true

module CommandPost
  module Layout
    # Renders the sidebar navigation menu.
    class SidebarComponent < ViewComponent::Base
      include CommandPost::ThemeHelper

      # Returns resources grouped by menu group.
      # @return [Hash{String => Array<Class>}]
      def grouped_resources
        CommandPost::ResourceRegistry.grouped
      end

      # @api private
      # @return [String] Configured admin panel title
      def title
        CommandPost.configuration.title
      end

      # @api private
      # @return [String, nil] Configured logo URL or path
      def logo
        CommandPost.configuration.logo
      end
    end
  end
end
