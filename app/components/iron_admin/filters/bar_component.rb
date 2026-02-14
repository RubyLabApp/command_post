# frozen_string_literal: true

module IronAdmin
  # Filter components for search and filtering records.
  module Filters
    # Renders the filter bar containing search and filter controls.
    class BarComponent < ViewComponent::Base
      renders_many :filters

      # @return [String] Form submission URL
      attr_reader :form_url

      # @return [String, nil] Current scope
      attr_reader :scope

      # @return [String, nil] Current search query
      attr_reader :query

      # @return [Integer] Number of active filters
      attr_reader :active_count

      # @param form_url [String] Form submission URL
      # @param scope [String, nil] Current scope
      # @param query [String, nil] Current query
      # @param active_count [Integer] Active filter count
      def initialize(form_url:, scope: nil, query: nil, active_count: 0)
        @form_url = form_url
        @scope = scope
        @query = query
        @active_count = active_count
      end

      # @api private
      # @return [IronAdmin::Configuration::Theme] Theme configuration
      def theme
        IronAdmin.configuration.theme
      end

      # @api private
      # @return [Boolean] Whether any filters are active
      def has_active_filters?
        active_count.positive?
      end

      # @api private
      # @return [String] CSS classes for filter dropdown trigger button
      def trigger_classes
        "#{theme.filter.trigger} #{theme.border_radius} " \
          "#{theme.label_text} #{theme.card_border} #{theme.card_bg}"
      end

      # @api private
      # @return [String] CSS classes for filter dropdown panel
      def dropdown_classes
        "#{theme.filter.panel} #{theme.border_radius} " \
          "#{theme.card_border} #{theme.card_bg} #{theme.card_shadow}-lg"
      end

      # @api private
      # @return [String] CSS classes for filter chevron icon
      def chevron_classes
        "#{theme.filter.chevron_icon} #{theme.muted_text}"
      end
    end
  end
end
