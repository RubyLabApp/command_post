# frozen_string_literal: true

module IronAdmin
  module Ui
    # Renders pagination controls for record lists.
    #
    # Uses Pagy for pagination logic.
    #
    # @example Basic pagination
    #   render IronAdmin::Ui::PaginationComponent.new(pagy: @pagy)
    class PaginationComponent < ViewComponent::Base
      include Pagy::Linkable

      # @return [Pagy] The Pagy pagination object
      attr_reader :pagy_obj

      # @param pagy [Pagy] Pagination object
      def initialize(pagy:)
        @pagy_obj = pagy
      end

      # @api private
      # @return [IronAdmin::Configuration::Theme] Theme configuration
      def theme
        IronAdmin.configuration.theme
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
        pg = theme.pagination
        if active
          "#{pg.page_base} #{pg.page_active}"
        else
          "#{pg.page_base} #{theme.card_bg} #{theme.card_border} #{theme.body_text} #{pg.page_inactive_hover}"
        end
      end

      # @api private
      # @param disabled [Boolean] Whether nav link is disabled
      # @return [String] CSS classes for prev/next navigation links
      def nav_link_classes(disabled: false)
        pg = theme.pagination
        if disabled
          "#{pg.nav_base} #{theme.card_bg} #{theme.card_border} #{pg.nav_disabled}"
        else
          "#{pg.nav_base} #{theme.card_bg} #{theme.card_border} #{theme.body_text} #{pg.nav_enabled_hover}"
        end
      end
    end
  end
end
