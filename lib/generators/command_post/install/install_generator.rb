# frozen_string_literal: true

module CommandPost
  # Rails generators for CommandPost.
  module Generators
    # Generator for installing CommandPost into a Rails application.
    #
    # This generator sets up the basic structure needed to use CommandPost:
    # - Creates the app/command_post directory for resource definitions
    # - Adds an initializer with default configuration
    # - Creates a sample dashboard
    # - Mounts the engine at /admin in routes
    #
    # @example Running the generator
    #   rails generate command_post:install
    #
    # @see file:docs/getting-started/installation.md Installation Guide
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      # Creates the directory for resource definitions.
      # @return [void]
      def create_command_post_directory
        empty_directory "app/command_post"
      end

      # Copies the initializer template with default configuration.
      # @return [void]
      def copy_initializer
        template "initializer.rb.tt", "config/initializers/command_post.rb"
      end

      # Copies the dashboard template.
      # @return [void]
      def copy_dashboard
        template "dashboard.rb.tt", "app/command_post/dashboard.rb"
      end

      # Adds the engine mount to config/routes.rb.
      # @return [void]
      def add_route
        route 'mount CommandPost::Engine => "/admin"'
      end
    end
  end
end
