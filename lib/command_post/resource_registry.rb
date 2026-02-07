# frozen_string_literal: true

module CommandPost
  # Registry that tracks all registered resource classes.
  #
  # Resources are automatically registered when they are defined (via the
  # inherited hook in {Resource}). This registry provides methods to look up
  # resources by name and retrieve them for the sidebar menu.
  #
  # @example Find a resource by name
  #   resource = CommandPost::ResourceRegistry.find("users")
  #   resource.model  #=> User
  #
  # @example List all resources
  #   CommandPost::ResourceRegistry.all.each do |resource|
  #     puts resource.label
  #   end
  #
  # @see CommandPost::Resource
  class ResourceRegistry
    class << self
      # Registers a resource class in the registry.
      #
      # Called automatically when a Resource subclass is defined.
      # Also triggers soft delete feature registration if applicable.
      #
      # @param resource_class [Class] The resource class to register
      # @return [Class] The registered resource class
      def register(resource_class)
        resource_class.register_soft_delete_features
        resources[resource_class.resource_name] = resource_class
      end

      # Returns all registered resource classes.
      #
      # @return [Array<Class>] All registered resource classes
      def all
        resources.values
      end

      # Finds a resource class by its name.
      #
      # @param resource_name [String] The pluralized resource name (e.g., "users")
      # @return [Class, nil] The resource class, or nil if not found
      #
      # @example
      #   CommandPost::ResourceRegistry.find("users")  #=> UserResource
      #   CommandPost::ResourceRegistry.find("orders") #=> OrderResource
      def find(resource_name)
        resources[resource_name]
      end

      # Returns resources grouped by their menu group.
      #
      # Resources without a group are placed in "Resources".
      #
      # @return [Hash{String => Array<Class>}] Resources grouped by menu section
      #
      # @example
      #   {
      #     "Users" => [UserResource, AdminResource],
      #     "Commerce" => [OrderResource, ProductResource],
      #     "Resources" => [SettingResource]
      #   }
      def grouped
        all.group_by { |r| r.menu_options[:group] || "Resources" }
      end

      # Returns resources sorted by menu priority.
      #
      # Lower priority values appear first. Resources without a priority
      # default to 999.
      #
      # @return [Array<Class>] Sorted resource classes
      def sorted
        all.sort_by { |r| r.menu_options[:priority] || 999 }
      end

      # Clears all registered resources.
      #
      # @api private
      # @return [void]
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
