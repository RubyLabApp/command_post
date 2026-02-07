# frozen_string_literal: true

module CommandPost
  module Ui
    # Renders pagination controls for record lists.
    #
    # Uses Pagy for pagination logic.
    #
    # @example Basic pagination
    #   render CommandPost::Ui::PaginationComponent.new(pagy: @pagy)
    class PaginationComponent < ViewComponent::Base
      include Pagy::Frontend

      # @return [Pagy] The Pagy pagination object
      attr_reader :pagy_obj

      # @param pagy [Pagy] Pagination object
      def initialize(pagy:)
        @pagy_obj = pagy
      end

      # @api private
      # @return [CommandPost::Configuration::Theme] Theme configuration
      def theme
        CommandPost.configuration.theme
      end

      # @api private
      # @return [Boolean] Whether to render pagination
      def render?
        pagy_obj.pages > 1
      end

      # @api private
      # @param active [Boolean] Whether this is the current page
      # @return [String] CSS classes for page number links
      def page_link_classes(active: false)
        base = "px-3 py-2 text-sm font-medium border transition-colors duration-150"
        if active
          "#{base} bg-indigo-50 border-indigo-500 text-indigo-600 z-10"
        else
          "#{base} #{theme.card_bg} #{theme.card_border} #{theme.body_text} hover:bg-gray-50"
        end
      end

      # @api private
      # @param disabled [Boolean] Whether nav link is disabled
      # @return [String] CSS classes for prev/next navigation links
      def nav_link_classes(disabled: false)
        base = "relative inline-flex items-center px-3 py-2 text-sm font-medium border transition-colors duration-150"
        if disabled
          "#{base} #{theme.card_bg} #{theme.card_border} text-gray-300 cursor-not-allowed"
        else
          "#{base} #{theme.card_bg} #{theme.card_border} #{theme.body_text} hover:bg-gray-50"
        end
      end
    end
  end
end
