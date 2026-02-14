# frozen_string_literal: true

module IronAdmin
  module Filters
    # Renders a select dropdown filter.
    class SelectFilterComponent < ViewComponent::Base
      # @return [Symbol] Filter name
      attr_reader :name

      # @return [String] Filter label
      attr_reader :label

      # @return [Array] Available options
      attr_reader :options

      # @return [String, nil] Currently selected value
      attr_reader :selected

      # @param name [Symbol] Filter name
      # @param options [Array] Available options
      # @param label [String, nil] Label text
      # @param selected [String, nil] Selected value
      def initialize(name:, options:, label: nil, selected: nil)
        @name = name
        @label = label || name.to_s.humanize
        @options = options
        @selected = selected
      end

      # @api private
      # @return [IronAdmin::Configuration::Theme] Theme configuration
      def theme
        IronAdmin.configuration.theme
      end

      # @api private
      # @return [String] Form field name
      def field_name
        "filters[#{name}]"
      end

      # @api private
      # @return [String] CSS classes for label elements
      def label_classes
        "#{theme.filter.label} #{theme.muted_text}"
      end

      # @api private
      # @return [String] CSS classes for select element
      def select_classes
        "#{theme.form.input_base} #{theme.form.select_extra} #{theme.border_radius} " \
          "#{theme.input_border} #{theme.card_bg} #{theme.body_text} #{theme.input_focus}"
      end

      # @api private
      # @return [String] Inline CSS style for dropdown chevron
      def chevron_style
        theme.form.select_chevron_style
      end
    end
  end
end
