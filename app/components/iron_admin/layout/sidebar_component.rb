# frozen_string_literal: true

module IronAdmin
  module Layout
    # Renders the sidebar navigation menu.
    class SidebarComponent < ViewComponent::Base
      include IronAdmin::ThemeHelper

      # Returns resources grouped by menu group.
      # @return [Hash{String => Array<Class>}]
      def grouped_resources
        IronAdmin::ResourceRegistry.grouped
      end

      # Returns tools grouped by menu group.
      # @return [Hash{String => Array<Class>}]
      def grouped_tools
        IronAdmin::ToolRegistry.grouped
      end

      # @api private
      # @return [String] Configured admin panel title
      def title
        IronAdmin.configuration.title
      end

      # @api private
      # @return [String, nil] Configured logo URL or path
      def logo
        IronAdmin.configuration.logo
      end
    end
  end
end
