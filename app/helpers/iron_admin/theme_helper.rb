# frozen_string_literal: true

module IronAdmin
  # Helper methods for accessing themed CSS classes.
  #
  # All methods compose strings exclusively from theme tokens.
  # No hardcoded framework classes — a different preset will
  # change every class string returned by these helpers.
  module ThemeHelper
    # Returns the current theme configuration.
    # @return [IronAdmin::Configuration::Theme]
    def t
      IronAdmin.configuration.theme
    end

    # @return [String] Primary button classes
    def cp_btn_primary
      "#{t.button.base} #{t.button.variants[:primary]} #{t.button.sizes[:md]}"
    end

    # @return [String] Large primary button classes
    def cp_btn_primary_lg
      "#{t.button.base} #{t.button.variants[:primary]} #{t.button.sizes[:lg]}"
    end

    # @return [String] Secondary button classes
    def cp_btn_secondary
      "#{t.button.base} #{t.button.variants[:secondary]} #{t.button.sizes[:lg]}"
    end

    # @return [String] Danger button classes
    def cp_btn_danger
      "#{t.button.base} #{t.button.variants[:danger]} #{t.button.sizes[:md]}"
    end

    # @return [String] Ghost button classes
    def cp_btn_ghost
      "#{t.button.base} #{t.button.variants[:ghost]} #{t.button.sizes[:md]}"
    end

    # @return [String] Link classes
    def cp_link
      t.link
    end

    # @return [String] Muted link classes
    def cp_link_muted
      t.link_muted
    end

    # @return [String] Focus ring classes
    def cp_focus
      t.input_focus
    end

    # @return [String] Text input classes
    def cp_input_class
      "#{t.form.input_base} #{t.layout.border_radius} #{t.form.input_border} " \
        "#{t.card.bg} #{t.typography.body_text} #{t.form.placeholder} #{t.form.input_focus}"
    end

    # @return [String] Select input classes
    def cp_select_class
      "#{t.form.input_base} #{t.layout.border_radius} #{t.form.input_border} " \
        "#{t.card.bg} #{t.typography.body_text} #{t.form.select_extra} " \
        "#{t.form.input_focus} #{t.form.select_svg}"
    end

    # @return [String] Textarea classes
    def cp_textarea_class
      "#{t.form.input_base} #{t.layout.border_radius} #{t.form.input_border} " \
        "#{t.card.bg} #{t.typography.body_text} #{t.form.placeholder} " \
        "#{t.form.input_focus} #{t.form.textarea_extra}"
    end

    # @return [String] Checkbox classes
    def cp_checkbox_class
      "#{t.form.checkbox_base} #{t.form.checkbox_checked}"
    end

    # @return [String] Filter input classes
    def cp_filter_input_class
      "#{t.form.filter_input} #{t.layout.border_radius} #{t.form.input_border} " \
        "#{t.card.bg} #{t.typography.body_text} #{t.form.input_focus}"
    end

    # @return [String] Search input classes
    def cp_search_class
      "#{t.form.search_input} #{t.layout.border_radius} #{t.form.input_border} " \
        "#{t.card.bg} #{t.typography.body_text} #{t.form.placeholder} #{t.form.input_focus}"
    end

    # @return [String] Navbar search input classes
    def cp_navbar_search_class
      "#{t.form.search_input} #{t.layout.border_radius} #{t.form.input_border} " \
        "#{t.navbar.search_bg} #{t.typography.body_text} #{t.form.placeholder} " \
        "#{t.form.input_focus} #{t.navbar.search_focus_bg}"
    end

    # @return [String] Active scope tab classes
    def cp_scope_active
      t.scope_active
    end

    # @return [String] Inactive scope tab classes
    def cp_scope_inactive
      t.scope_inactive
    end

    # @return [String] Badge count classes
    def cp_badge_count
      "#{t.badge.count_base} #{t.badge.count}"
    end

    # @return [String] Filter apply button classes
    def cp_btn_filter_apply
      "#{t.button.base} #{t.button.variants[:primary]} #{t.button.sizes[:sm]}"
    end

    # @return [String] Sidebar background classes
    def cp_sidebar_bg
      t.sidebar_bg
    end

    # @return [String] Sidebar title classes
    def cp_sidebar_title
      t.sidebar_title
    end

    # @return [String] Sidebar link classes
    def cp_sidebar_link
      "#{t.sidebar.link} #{t.sidebar.link_hover}"
    end

    # @return [String] Sidebar group label classes
    def cp_sidebar_group_label
      t.sidebar_group_label
    end

    # @return [String] Heading classes
    def cp_heading
      "#{t.heading_weight} #{t.font_family}".strip
    end

    # @return [String] Card classes
    def cp_card
      "#{t.card_bg} #{t.border_radius} #{t.card_shadow}"
    end

    # @return [String] Body text classes
    def cp_body_text
      t.body_text
    end

    # @return [String] Muted text classes
    def cp_muted_text
      t.muted_text
    end

    # @return [String] Label text classes
    def cp_label_text
      t.label_text
    end

    # @return [String] Table header background classes
    def cp_table_header_bg
      t.table_header_bg
    end

    # @return [String] Table row hover classes
    def cp_table_row_hover
      t.table_row_hover
    end

    # @return [String] Table border classes
    def cp_table_border
      t.table_border
    end

    # @return [String] File input classes
    def cp_file_input_class
      "#{t.form.file_input} #{t.typography.body_text}"
    end
  end
end
