module CommandPost
  class ResourceRegistry
    class << self
      def register(resource_class)
        resource_class.register_soft_delete_features
        resources[resource_class.resource_name] = resource_class
      end

      def all
        resources.values
      end

      def find(resource_name)
        resources[resource_name]
      end

      def grouped
        all.group_by { |r| r.menu_options[:group] || "Resources" }
      end

      def sorted
        all.sort_by { |r| r.menu_options[:priority] || 999 }
      end

      def reset!
        @resources = {}
      end

      private

      def resources
        @resources ||= {}
      end
    end
  end
end
