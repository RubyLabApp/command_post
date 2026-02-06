# frozen_string_literal: true

module CommandPost
  class AuditEntry < ActiveRecord::Base
    self.table_name = "command_post_audit_entries"

    serialize :record_changes, coder: JSON

    scope :by_resource, ->(resource) { where(resource: resource) }
    scope :by_action, ->(action) { where(action: action) }
    scope :by_record_id, ->(record_id) { where(record_id: record_id) }
    scope :from_date, ->(date) { where("created_at >= ?", date) }
    scope :to_date, ->(date) { where("created_at <= ?", date) }
  end
end
