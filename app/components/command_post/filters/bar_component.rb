# frozen_string_literal: true

module CommandPost
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
      # @return [CommandPost::Configuration::Theme] Theme configuration
      def theme
        CommandPost.configuration.theme
      end

      # @api private
      # @return [Boolean] Whether any filters are active
      def has_active_filters?
        active_count.positive?
      end

      # @api private
      # @return [String] CSS classes for filter dropdown trigger button
      def trigger_classes
        "inline-flex items-center gap-2 px-4 cursor-pointer select-none text-sm font-medium " \
          "#{theme.border_radius} border shadow-sm transition duration-150 " \
          "#{theme.label_text} #{theme.card_border} #{theme.card_bg} py-2.5 hover:bg-gray-50"
      end

      # @api private
      # @return [String] CSS classes for filter dropdown panel
      def dropdown_classes
        "absolute right-0 top-full mt-2 w-72 border z-20 #{theme.border_radius} " \
          "#{theme.card_border} #{theme.card_bg} #{theme.card_shadow}-lg"
      end
    end
  end
end
