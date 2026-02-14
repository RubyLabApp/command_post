# frozen_string_literal: true

module IronAdmin
  # Controller for viewing the audit log.
  #
  # Provides a filterable view of all admin panel actions when
  # audit logging is enabled.
  #
  # Access via /admin/audit
  #
  # @see IronAdmin::AuditLog
  # @see IronAdmin::Configuration#audit_enabled
  class AuditController < ApplicationController
    # Lists audit log entries with optional filters.
    #
    # Supports filtering by resource, action, and date range.
    #
    # @return [void]
    def index
      @entries = filtered_entries.reverse
    end

    private

    # @api private
    def filtered_entries
      filters = {}
      filters[:resource] = params[:resource] if params[:resource].present?
      filters[:action] = params[:action_filter] if params[:action_filter].present?
      filters[:from] = Time.zone.parse(params[:from]) if params[:from].present?
      filters[:to] = Time.zone.parse(params[:to]) if params[:to].present?

      AuditLog.query(filters)
    end
  end
end
