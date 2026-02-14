# frozen_string_literal: true

require "iron_admin/themes/tailwind/components"
require "iron_admin/themes/tailwind/layout"
require "iron_admin/themes/tailwind/data"
require "iron_admin/themes/tailwind/views"

module IronAdmin
  module Themes
    # Default Tailwind CSS preset.
    #
    # Returns a nested hash of ALL style tokens used throughout IronAdmin.
    # Each top-level key corresponds to a Theme sub-group (e.g., `button`, `badge`).
    #
    # To create a custom preset, define a module with a `self.defaults` method
    # that returns a hash with the same structure.
    #
    # @example Using the preset
    #   IronAdmin.configure do |config|
    #     config.theme_preset = :tailwind  # default
    #   end
    module Tailwind
      def self.defaults
        {
          # Layout groups
          layout: Layout.layout,
          sidebar: Layout.sidebar,
          navbar: Layout.navbar,
          card: Layout.card,
          typography: Layout.typography,
          link: Layout.link,
          scope: Layout.scope,
          # UI component groups
          button: Components.button,
          badge: Components.badge,
          modal: Components.modal,
          alert: Components.alert,
          dropdown: Components.dropdown,
          tooltip: Components.tooltip,
          pagination: Components.pagination,
          empty_state: Components.empty_state,
          # Data groups
          form: Data.form,
          table: Data.table,
          chart: Data.chart,
          display: Views.display,
          filter: Views.filter,
          audit: Views.audit,
        }
      end
    end
  end
end
