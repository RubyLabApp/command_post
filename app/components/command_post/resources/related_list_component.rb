module CommandPost
  module Resources
    class RelatedListComponent < ViewComponent::Base
      attr_reader :association, :records, :limit

      def initialize(association:, records:, limit: 20)
        @association = association
        @records = records.limit(limit)
        @limit = limit
      end

      def theme
        CommandPost.configuration.theme
      end

      def title
        association[:name].to_s.humanize
      end

      def resource_name
        association[:resource].resource_name
      end

      def display_method
        association[:display]
      end

      def view_all_url
        helpers.command_post.resources_path(resource_name)
      end

      def record_url(record)
        helpers.command_post.resource_path(resource_name, record)
      end

      def render?
        records.any?
      end
    end
  end
end
