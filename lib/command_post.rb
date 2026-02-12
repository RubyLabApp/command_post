# frozen_string_literal: true

require "command_post/version"
require "command_post/configuration"
require "command_post/field"
require "command_post/field_type_config"
require "command_post/field_type_registry"
require "command_post/field_inferrer"
require "command_post/resource"
require "command_post/resource_registry"
require "command_post/policy"
require "command_post/dashboard"
require "command_post/audit_log"
require "command_post/engine"

# CommandPost is a convention-over-configuration admin panel engine for Ruby on Rails.
#
# It automatically generates admin interfaces from your database schema with minimal
# configuration, following Rails conventions.
#
# == Getting Started
#
# 1. Add the gem to your Gemfile and run bundle install
# 2. Run the install generator: `rails generate command_post:install`
# 3. Mount the engine in config/routes.rb: `mount CommandPost::Engine => "/admin"`
# 4. Create resources in app/command_post/ for each model you want to manage
#
# == Key Concepts
#
# === Resources
# Resources define how models appear in the admin panel. Each resource is a class
# that inherits from {CommandPost::Resource} and provides a DSL for configuring
# fields, filters, actions, and authorization.
#
#   class UserResource < CommandPost::Resource
#     field :email, readonly: true
#     field :password_digest, visible: false
#     searchable :name, :email
#     filter :role, type: :select, options: %w[admin user]
#   end
#
# === Dashboard
# The dashboard is the admin panel home page. Create a class inheriting from
# {CommandPost::Dashboard} to define metrics, charts, and recent record lists.
#
#   class AdminDashboard < CommandPost::Dashboard
#     metric :total_users do
#       User.count
#     end
#     recent :orders, limit: 10
#   end
#
# === Configuration
# Global settings are configured in an initializer using {.configure}.
#
#   CommandPost.configure do |config|
#     config.title = "My Admin"
#     config.authenticate { |c| c.redirect_to "/login" unless c.current_user }
#   end
#
# @see CommandPost::Resource
# @see CommandPost::Dashboard
# @see CommandPost::Configuration
module CommandPost
  class << self
    # @return [Class, nil] The dashboard class for the application
    attr_accessor :dashboard_class

    # Returns the global configuration instance.
    #
    # @return [CommandPost::Configuration] The configuration object
    #
    # @example Access configuration
    #   CommandPost.configuration.per_page  #=> 25
    def configuration
      @configuration ||= Configuration.new
    end

    # Configures CommandPost using a block.
    #
    # This is the primary way to configure the admin panel. Call this method
    # in an initializer (config/initializers/command_post.rb).
    #
    # @yield [config] Block that configures CommandPost
    # @yieldparam config [CommandPost::Configuration] The configuration object
    #
    # @example Basic configuration
    #   CommandPost.configure do |config|
    #     config.title = "My Admin Panel"
    #     config.per_page = 50
    #
    #     config.authenticate do |controller|
    #       controller.redirect_to "/login" unless controller.session[:user_id]
    #     end
    #
    #     config.current_user do |controller|
    #       User.find_by(id: controller.session[:user_id])
    #     end
    #   end
    #
    # @return [void]
    def configure
      yield configuration
    end

    # Resets all configuration to defaults.
    #
    # Primarily used in tests to ensure a clean state between examples.
    #
    # @api private
    # @return [void]
    def reset_configuration!
      @configuration = Configuration.new
      @dashboard_class = nil
    end

    def register_field_type(type_name, &)
      FieldTypeRegistry.register(type_name, &)
    end
  end
end
