# frozen_string_literal: true

module IronAdmin
  module Resources
    # Renders a list of related records for has_many associations.
    class RelatedListComponent < ViewComponent::Base
      # @return [Hash] Association configuration
      attr_reader :association

      # @return [ActiveRecord::Relation] Related records
      attr_reader :records

      # @return [Integer] Max records to show
      attr_reader :limit

      # @param association [Hash] Association config
      # @param records [ActiveRecord::Relation] Records
      # @param limit [Integer] Max records (default: 20)
      def initialize(association:, records:, limit: 20)
        @association = association
        @records = records.limit(limit)
        @limit = limit
      end

      # @api private
      # @return [IronAdmin::Configuration::Theme] Theme configuration
      def theme
        IronAdmin.configuration.theme
      end

      # @api private
      # @return [String] Humanized association title
      def title
        association[:name].to_s.humanize
      end

      # @api private
      # @return [String] Associated resource name
      def resource_name
        association[:resource].resource_name
      end

      # @api private
      # @return [Symbol, Proc, nil] Display method for record labels
      def display_method
        association[:display]
      end

      # @api private
      # @return [String] URL to view all records
      def view_all_url
        helpers.iron_admin.resources_path(resource_name)
      end

      # @api private
      # @param record [ActiveRecord::Base] The record
      # @return [String] URL to view the record
      def record_url(record)
        helpers.iron_admin.resource_path(resource_name, record)
      end

      # @api private
      # @return [Boolean] Whether to render the component
      def render?
        records.any?
      end
    end
  end
end
