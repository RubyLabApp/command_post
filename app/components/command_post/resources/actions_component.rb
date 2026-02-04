module CommandPost
  module Resources
    class ActionsComponent < ViewComponent::Base
      attr_reader :actions, :record, :resource_class

      def initialize(actions:, record:, resource_class:)
        @actions = actions
        @record = record
        @resource_class = resource_class
      end

      def theme
        CommandPost.configuration.theme
      end

      def action_url(action)
        helpers.command_post.resource_action_path(resource_class.resource_name, record, action[:name])
      end

      def render?
        actions.any?
      end
    end
  end
end
