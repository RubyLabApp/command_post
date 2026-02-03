module CommandPost
  class Dashboard
    class RecentTableComponent < ViewComponent::Base
      def initialize(resource_name:, records:)
        @resource_name = resource_name
        @records = records
      end

      def label
        @resource_name.to_s.humanize.pluralize
      end

      def fields
        resource_class = CommandPost::ResourceRegistry.find(@resource_name.to_s.pluralize)
        return [] unless resource_class

        resource_class.resolved_fields.first(4)
      end
    end
  end
end
