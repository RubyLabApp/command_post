module CommandPost
  module UI
    class EmptyStateComponent < ViewComponent::Base
      attr_reader :title, :description, :icon, :action_text, :action_href

      def initialize(title: "No results found", description: nil, icon: "inbox",
                     action_text: nil, action_href: nil)
        @title = title
        @description = description
        @icon = icon
        @action_text = action_text
        @action_href = action_href
      end

      def theme
        CommandPost.configuration.theme
      end

      def has_action?
        action_text.present? && action_href.present?
      end
    end
  end
end
