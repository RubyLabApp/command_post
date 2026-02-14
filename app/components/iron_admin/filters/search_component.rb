# frozen_string_literal: true

module IronAdmin
  module Filters
    # Renders the search input in the filter bar.
    class SearchComponent < ViewComponent::Base
      # @return [String, nil] Current search value
      attr_reader :value

      # @return [String] Placeholder text
      attr_reader :placeholder

      # @return [String] Form submission URL
      attr_reader :form_url

      # @return [Hash] Hidden params to preserve
      attr_reader :hidden_params

      # @param form_url [String] Form submission URL
      # @param value [String, nil] Current value
      # @param placeholder [String] Placeholder text
      # @param hidden_params [Hash] Hidden params
      def initialize(form_url:, value: nil, placeholder: "Search...", hidden_params: {})
        @value = value
        @placeholder = placeholder
        @form_url = form_url
        @hidden_params = hidden_params
      end

      # @api private
      # @return [IronAdmin::Configuration::Theme] Theme configuration
      def theme
        IronAdmin.configuration.theme
      end

      # @api private
      # @return [String] CSS classes for search input field
      def input_classes
        "#{theme.form.search_input} #{theme.border_radius} #{theme.input_border} " \
          "#{theme.navbar_search_bg} #{theme.body_text} #{theme.input_focus} " \
          "#{theme.navbar_search_focus_bg}"
      end
    end
  end
end
