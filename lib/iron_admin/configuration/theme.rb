# frozen_string_literal: true

require "iron_admin/configuration/theme/styles"
require "iron_admin/themes/tailwind"

module IronAdmin
  class Configuration
    # Theme configuration for customizing the admin panel appearance.
    #
    # Supports two APIs:
    #
    # 1. **Flat (backward-compatible):** `t.btn_primary`, `t.sidebar_bg`, etc.
    # 2. **Nested (new):** `t.button.variants[:primary]`, `t.sidebar.bg`, etc.
    #
    # Both APIs read/write the same underlying data. The flat API delegates
    # to the nested Styles sub-objects.
    #
    # @example Flat API (backward-compatible)
    #   IronAdmin.configure do |config|
    #     config.theme do |t|
    #       t.btn_primary = "bg-blue-600 text-white hover:bg-blue-700"
    #       t.sidebar_bg = "bg-slate-900"
    #     end
    #   end
    #
    # @example Nested API
    #   IronAdmin.configure do |config|
    #     config.theme do |t|
    #       t.button.variants[:primary] = "bg-blue-600 text-white"
    #       t.sidebar.bg = "bg-slate-900"
    #     end
    #   end
    #
    # @see IronAdmin::Configuration#theme
    # @see IronAdmin::Themes::Tailwind
    class Theme
      # Nested style group accessors.
      STYLE_GROUPS = %i[
        layout button badge form table modal alert dropdown
        tooltip pagination sidebar navbar card typography
        links scope chart display empty_state filter audit
      ].freeze

      attr_reader(*STYLE_GROUPS)

      # Backward-compatible flat aliases mapped to their nested path.
      # Each entry maps `flat_name => [group, key]` for simple delegation,
      # or `flat_name => [group, hash_key, entry]` for hash-entry access.
      FLAT_ALIASES = {
        # Buttons → button.variants[key]
        btn_primary: %i[button variants primary],
        btn_secondary: %i[button variants secondary],
        btn_danger: %i[button variants danger],
        btn_ghost: %i[button variants ghost],
        # Links → links.key
        link: %i[links primary],
        link_muted: %i[links muted],
        # Form → form.key
        focus_ring: %i[form focus_ring],
        input_border: %i[form input_border],
        input_focus: %i[form input_focus],
        checkbox_checked: %i[form checkbox_checked],
        # Scopes → scope.key
        scope_active: %i[scope active],
        scope_inactive: %i[scope inactive],
        # Badge → badge.key
        badge_count: %i[badge count],
        # Sidebar → sidebar.key
        sidebar_bg: %i[sidebar bg],
        sidebar_title: %i[sidebar title],
        sidebar_link: %i[sidebar link],
        sidebar_link_hover: %i[sidebar link_hover],
        sidebar_group_label: %i[sidebar group_label],
        # Navbar → navbar.key
        navbar_bg: %i[navbar bg],
        navbar_border: %i[navbar border],
        navbar_search_bg: %i[navbar search_bg],
        navbar_search_focus_bg: %i[navbar search_focus_bg],
        # Table → table.key
        table_header_bg: %i[table header_bg],
        table_row_hover: %i[table row_hover],
        table_border: %i[table border],
        # Card → card.key
        card_bg: %i[card bg],
        card_border: %i[card border],
        card_shadow: %i[card shadow],
        # Typography → typography.key
        font_family: %i[typography font_family],
        heading_weight: %i[typography heading_weight],
        body_text: %i[typography body_text],
        muted_text: %i[typography muted_text],
        label_text: %i[typography label_text],
        # Layout → layout.key
        main_bg: %i[layout main_bg],
        border_radius: %i[layout border_radius],
        # Chart → chart.key
        chart_colors: %i[chart colors],
        chart_border_color: %i[chart border_color],
      }.freeze

      # Define backward-compatible getter and setter for each flat alias.
      FLAT_ALIASES.each do |flat_name, path|
        group_name = path[0]

        if path.length == 3
          # Hash-entry access: e.g., button.variants[:primary]
          hash_key = path[1]
          entry_key = path[2]
          define_method(flat_name) { public_send(group_name).public_send(hash_key)[entry_key] }
          define_method(:"#{flat_name}=") { |v| public_send(group_name).public_send(hash_key)[entry_key] = v }
        else
          # Simple delegation: e.g., sidebar.bg
          attr_key = path[1]
          define_method(flat_name) { public_send(group_name).public_send(attr_key) }
          define_method(:"#{flat_name}=") { |v| public_send(group_name).public_send(:"#{attr_key}=", v) }
        end
      end

      # Creates a new Theme with defaults from the given preset.
      #
      # @param preset [Module] A preset module responding to `.defaults` (default: Tailwind)
      def initialize(preset: IronAdmin::Themes::Tailwind)
        apply_preset(preset)
      end

      # Applies a preset, replacing all style tokens with the preset defaults.
      #
      # @param preset [Module] A preset module responding to `.defaults`
      # @return [void]
      def apply_preset(preset)
        preset.defaults.each do |group_name, attrs|
          accessor_name = group_name == :link ? :links : group_name
          instance_variable_set(:"@#{accessor_name}", Styles.new(**attrs))
        end
      end
    end
  end
end
