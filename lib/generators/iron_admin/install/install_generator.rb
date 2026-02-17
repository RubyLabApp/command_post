# frozen_string_literal: true

module IronAdmin
  # Rails generators for IronAdmin.
  module Generators
    # Generator for installing IronAdmin into a Rails application.
    #
    # This generator sets up the basic structure needed to use IronAdmin:
    # - Creates the app/iron_admin directory for resource definitions
    # - Adds an initializer with default configuration
    # - Creates a sample dashboard
    # - Mounts the engine at /admin in routes
    #
    # @example Running the generator
    #   rails generate iron_admin:install
    #
    # @see file:docs/getting-started/installation.md Installation Guide
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      # Creates the directory structure for resource and dashboard definitions.
      # @return [void]
      def create_iron_admin_directories
        empty_directory "app/iron_admin/resources"
        empty_directory "app/iron_admin/dashboards"
      end

      # Copies the initializer template with default configuration.
      # @return [void]
      def copy_initializer
        template "initializer.rb.tt", "config/initializers/iron_admin.rb"
      end

      # Copies the dashboard template.
      # @return [void]
      def copy_dashboard
        template "dashboard.rb.tt", "app/iron_admin/dashboards/admin_dashboard.rb"
      end

      # Adds the engine mount to config/routes.rb.
      # @return [void]
      def add_route
        route 'mount IronAdmin::Engine => "/admin"'
      end
    end
  end
end
