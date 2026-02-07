# frozen_string_literal: true

module CommandPost
  module Generators
    # Generator for creating new CommandPost resource definitions.
    #
    # Creates a resource file in app/command_post/ that configures
    # how a model appears in the admin panel.
    #
    # @example Generate a resource for User model
    #   rails generate command_post:resource User
    #
    # @example Generate a namespaced resource
    #   rails generate command_post:resource Admin::User
    #
    # @see CommandPost::Resource
    class ResourceGenerator < Rails::Generators::NamedBase
      source_root File.expand_path("templates", __dir__)

      # Creates the resource file from template.
      # @return [void]
      def create_resource_file
        template "resource.rb.tt", File.join("app/command_post", class_path, "#{file_name}_resource.rb")
      end
    end
  end
end
