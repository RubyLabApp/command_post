# frozen_string_literal: true

module CommandPost
  # ActiveRecord model for persistent audit log entries.
  #
  # Created by the install_audit generator. Stores a record of all
  # admin panel actions when database storage is enabled.
  #
  # @see CommandPost::AuditLog
  # @see CommandPost::Generators::InstallAuditGenerator
  class AuditEntry < ApplicationRecord
    self.table_name = "command_post_audit_entries"

    serialize :record_changes, coder: JSON

    # @!method by_resource(resource)
    #   @param resource [String] Resource name
    #   @return [ActiveRecord::Relation]
    scope :by_resource, ->(resource) { where(resource: resource) }

    # @!method by_action(action)
    #   @param action [String] Action name
    #   @return [ActiveRecord::Relation]
    scope :by_action, ->(action) { where(action: action) }

    # @!method by_record_id(record_id)
    #   @param record_id [Integer, String] Record ID
    #   @return [ActiveRecord::Relation]
    scope :by_record_id, ->(record_id) { where(record_id: record_id) }

    # @!method from_date(date)
    #   @param date [Date, Time] Start date
    #   @return [ActiveRecord::Relation]
    scope :from_date, ->(date) { where(created_at: date..) }

    # @!method to_date(date)
    #   @param date [Date, Time] End date
    #   @return [ActiveRecord::Relation]
    scope :to_date, ->(date) { where(created_at: ..date) }

    # Checks if the audit entries table exists.
    # @return [Boolean]
    def self.table_exists?
      super
    rescue ActiveRecord::NoDatabaseError, ActiveRecord::StatementInvalid
      false
    end
  end
end
