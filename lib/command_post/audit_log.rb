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

        if CommandPost.configuration.audit_storage == :database
          log_to_database(event)
        else
          log_to_memory(event)
        end
      end

      def query(filters = {})
        if CommandPost.configuration.audit_storage == :database
          query_database(filters)
        else
          query_memory(filters)
        end
      end

      def clear!
        @entries = []
        if CommandPost.configuration.audit_storage == :database
          AuditEntry.delete_all if defined?(AuditEntry) && AuditEntry.table_exists?
        end
      end

      private

      def log_to_memory(event)
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

      def log_to_database(event)
        AuditEntry.create!(
          user_identifier: event.user.respond_to?(:id) ? event.user.id.to_s : event.user.to_s,
          action: event.action.to_s,
          resource: event.resource.to_s,
          record_id: event.record_id,
          record_changes: event.changes,
          ip_address: event.ip_address
        )
      end

      def query_memory(filters)
        result = entries
        result = result.select { |e| e.resource == filters[:resource] } if filters[:resource]
        result = result.select { |e| e.timestamp >= filters[:from] } if filters[:from]
        result = result.select { |e| e.timestamp <= filters[:to] } if filters[:to]
        result = result.select { |e| e.action.to_s == filters[:action].to_s } if filters[:action]
        result = result.select { |e| e.record_id.to_s == filters[:record_id].to_s } if filters[:record_id]
        result
      end

      def query_database(filters)
        scope = AuditEntry.all
        scope = scope.by_resource(filters[:resource]) if filters[:resource]
        scope = scope.by_action(filters[:action]) if filters[:action]
        scope = scope.by_record_id(filters[:record_id]) if filters[:record_id]
        scope = scope.from_date(filters[:from]) if filters[:from]
        scope = scope.to_date(filters[:to]) if filters[:to]
        scope.order(created_at: :desc)
      end
    end
  end
end
