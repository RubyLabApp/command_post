# frozen_string_literal: true

module IronAdmin
  module Generators
    # Generator for creating new IronAdmin resource definitions.
    #
    # Creates a resource file in app/iron_admin/ that configures
    # how a model appears in the admin panel.
    #
    # @example Generate a resource for User model
    #   rails generate iron_admin:resource User
    #
    # @example Generate a namespaced resource
    #   rails generate iron_admin:resource Admin::User
    #
    # @see IronAdmin::Resource
    class ResourceGenerator < Rails::Generators::NamedBase
      source_root File.expand_path("templates", __dir__)

      # Creates the resource file from template.
      # @return [void]
      def create_resource_file
        template "resource.rb.tt", File.join("app/iron_admin", class_path, "#{file_name}_resource.rb")
      end
    end
  end
end
