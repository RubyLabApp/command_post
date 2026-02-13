# frozen_string_literal: true

module CommandPost
  module Dashboards
    # Renders a table of recent records on the dashboard.
    class RecentTableComponent < ViewComponent::Base
      include CommandPost::ApplicationHelper
      include CommandPost::FieldDisplayHelper
      include CommandPost::ThemeHelper

      # @param resource_name [Symbol, String] Resource name
      # @param records [ActiveRecord::Relation] Records to display
      def initialize(resource_name:, records:)
        @resource_name = resource_name
        @records = records
      end

      # @api private
      # @return [String] Humanized and pluralized resource label
      def label
        @resource_name.to_s.humanize.pluralize
      end

      # @api private
      # @return [Array<CommandPost::Field>] First 4 fields from the resource
      def fields
        resource_class = CommandPost::ResourceRegistry.find(@resource_name.to_s.pluralize)
        return [] unless resource_class

        resource_class.resolved_fields.first(4)
      end

      # @api private
      # @return [String, nil] Formatted field value for display
      def display_value(record, field)
        display_index_field_value(record, field)
      end

      # Delegate route helpers to the view context so included helpers work
      delegate :command_post, :main_app, to: :helpers
    end
  end
end
