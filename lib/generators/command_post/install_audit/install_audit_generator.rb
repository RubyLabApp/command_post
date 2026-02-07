# frozen_string_literal: true

module CommandPost
  module Generators
    class InstallAuditGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.expand_path("templates", __dir__)

      def create_migration
        migration_template "create_command_post_audit_entries.rb.tt",
                           "db/migrate/create_command_post_audit_entries.rb"
      end

      def self.next_migration_number(_dirname)
        Time.now.utc.strftime("%Y%m%d%H%M%S")
      end
    end
  end
end
