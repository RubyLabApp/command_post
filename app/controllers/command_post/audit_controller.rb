# frozen_string_literal: true

module CommandPost
  class AuditController < ApplicationController
    def index
      @entries = filtered_entries.reverse
    end

    private

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
