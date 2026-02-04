module CommandPost
  module Resources
    class BulkActionsComponent < ViewComponent::Base
      attr_reader :actions, :resource_class

      def initialize(actions:, resource_class:)
        @actions = actions
        @resource_class = resource_class
      end

      def theme
        CommandPost.configuration.theme
      end

      def action_url(action)
        helpers.command_post.resource_bulk_action_path(resource_class.resource_name, action[:name])
      end

      def render?
        actions.any?
      end
    end
  end
end
