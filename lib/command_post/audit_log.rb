# frozen_string_literal: true

module CommandPost
  class AuditLog
    class Entry
      attr_accessor :user, :action, :resource, :record_id, :changes, :ip_address, :timestamp

      def initialize(attrs = {})
        attrs.each { |k, v| send("#{k}=", v) }
        @timestamp ||= Time.current
      end

      def to_h
        {
          user: user,
          action: action,
          resource: resource,
          record_id: record_id,
          changes: changes,
          ip_address: ip_address,
          timestamp: timestamp,
        }
      end
    end

    class << self
      def entries
        @entries ||= []
      end

      def log(event)
        return unless CommandPost.configuration.audit_enabled

        entry = Entry.new(
          user: event.user,
          action: event.action,
          resource: event.resource,
          record_id: event.record_id,
          changes: event.changes,
          ip_address: event.ip_address
        )

        entries << entry
        entry
      end

      def query(filters = {})
        result = entries
        result = result.select { |e| e.resource == filters[:resource] } if filters[:resource]
        result = result.select { |e| e.timestamp >= filters[:from] } if filters[:from]
        result = result.select { |e| e.timestamp <= filters[:to] } if filters[:to]
        result = result.select { |e| e.action.to_s == filters[:action].to_s } if filters[:action]
        result = result.select { |e| e.record_id.to_s == filters[:record_id].to_s } if filters[:record_id]
        result
      end

      def clear!
        @entries = []
      end
    end
  end
end
