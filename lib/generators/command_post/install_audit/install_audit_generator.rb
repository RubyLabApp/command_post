# frozen_string_literal: true

module CommandPost
  module Generators
    # Generator for setting up database-backed audit logging.
    #
    # Creates the migration for the audit_entries table, which stores
    # a persistent log of all admin panel actions.
    #
    # @example Running the generator
    #   rails generate command_post:install_audit
    #   rails db:migrate
    #
    # @example Enabling database audit storage
    #   CommandPost.configure do |config|
    #     config.audit_enabled = true
    #     config.audit_storage = :database
    #   end
    #
    # @see CommandPost::AuditLog
    # @see CommandPost::Configuration#audit_storage
    class InstallAuditGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.expand_path("templates", __dir__)

      # Creates the audit entries migration.
      # @return [void]
      def create_migration
        migration_template "create_command_post_audit_entries.rb.tt",
                           "db/migrate/create_command_post_audit_entries.rb"
      end

      # @api private
      # Generates the next migration number based on current timestamp.
      # @return [String] Migration timestamp
      def self.next_migration_number(_dirname)
        Time.now.utc.strftime("%Y%m%d%H%M%S")
      end
    end
  end
end
