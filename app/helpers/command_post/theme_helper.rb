# frozen_string_literal: true

module CommandPost
  # Helper methods for accessing themed CSS classes.
  #
  # Provides convenience methods for generating Tailwind class strings
  # based on the current theme configuration.
  module ThemeHelper
    # Returns the current theme configuration.
    # @return [CommandPost::Configuration::Theme]
    def t
      CommandPost.configuration.theme
    end

    # @return [String] Primary button classes
    def cp_btn_primary
      "inline-flex items-center px-4 py-2 #{t.border_radius} #{t.btn_primary} " \
        "transition duration-150 ease-in-out"
    end

    # @return [String] Large primary button classes
    def cp_btn_primary_lg
      "inline-flex items-center px-5 text-sm font-medium #{t.border_radius} shadow-sm " \
        "#{t.btn_primary} transition duration-150 ease-in-out cursor-pointer py-2.5"
    end

    # @return [String] Secondary button classes
    def cp_btn_secondary
      "inline-flex items-center px-5 text-sm font-medium #{t.border_radius} shadow-sm " \
        "#{t.btn_secondary} transition duration-150 ease-in-out py-2.5"
    end

    # @return [String] Danger button classes
    def cp_btn_danger
      "px-4 py-2 #{t.border_radius} #{t.btn_danger}"
    end

    # @return [String] Ghost button classes
    def cp_btn_ghost
      "inline-flex items-center gap-2 px-4 py-2 #{t.border_radius} #{t.btn_ghost}"
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
      "block w-full appearance-none #{t.border_radius} border #{t.input_border} #{t.card_bg} px-3.5 py-2.5 text-sm " \
        "#{t.body_text} shadow-sm outline-none placeholder:text-gray-400 transition duration-150 ease-in-out #{t.input_focus}"
    end

    # @return [String] Select input classes
    def cp_select_class
      "block w-full appearance-none #{t.border_radius} border #{t.input_border} #{t.card_bg} px-3.5 py-2.5 pr-10 text-sm " \
        "#{t.body_text} shadow-sm outline-none transition duration-150 ease-in-out #{t.input_focus} " \
        "bg-[url('data:image/svg+xml;charset=utf-8,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20" \
        "viewBox%3D%220%200%2020%2020%22%20fill%3D%22%236b7280%22%3E%3Cpath%20fill-rule%3D%22evenodd%22%20d%3D%22" \
        "M5.23%207.21a.75.75%200%20011.06.02L10%2011.168l3.71-3.938a.75.75%200%20111.08%201.04l-4.25%204.5a.75.75" \
        "%200%2001-1.08%200l-4.25-4.5a.75.75%200%2001.02-1.06z%22%20clip-rule%3D%22evenodd%22%2F%3E%3C%2Fsvg%3E')] " \
        "bg-[length:1.25rem_1.25rem] bg-[position:right_0.5rem_center] bg-no-repeat"
    end

    # @return [String] Textarea classes
    def cp_textarea_class
      "block w-full appearance-none #{t.border_radius} border #{t.input_border} #{t.card_bg} px-3.5 py-2.5 text-sm " \
        "#{t.body_text} shadow-sm outline-none placeholder:text-gray-400 transition duration-150 ease-in-out " \
        "#{t.input_focus} resize-y"
    end

    # @return [String] Checkbox classes
    def cp_checkbox_class
      "h-4.5 w-4.5 appearance-none rounded border #{t.input_border} #{t.card_bg} shadow-sm transition duration-150 " \
        "ease-in-out #{t.checkbox_checked} " \
        "checked:bg-[url('data:image/svg+xml;charset=utf-8,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg" \
        "%22%20viewBox%3D%220%200%2020%2020%22%20fill%3D%22white%22%3E%3Cpath%20fill-rule%3D%22evenodd%22%20d%3D%22" \
        "M16.707%205.293a1%201%200%20010%201.414l-8%208a1%201%200%2001-1.414%200l-4-4a1%201%200%20011.414-1.414L8" \
        "%2012.586l7.293-7.293a1%201%200%20011.414%200z%22%20clip-rule%3D%22evenodd%22%2F%3E%3C%2Fsvg%3E')] " \
        "bg-[length:100%_100%] bg-center bg-no-repeat focus:ring-offset-1 cursor-pointer"
    end

    # @return [String] Filter input classes
    def cp_filter_input_class
      "block w-full appearance-none #{t.border_radius} border #{t.input_border} #{t.card_bg} px-3 py-2 text-sm " \
        "#{t.body_text} shadow-sm outline-none transition duration-150 ease-in-out #{t.input_focus}"
    end

    # @return [String] Search input classes
    def cp_search_class
      "block w-full appearance-none #{t.border_radius} border #{t.input_border} #{t.card_bg} pl-10 pr-4 py-2 text-sm " \
        "#{t.body_text} shadow-sm outline-none placeholder:text-gray-400 transition duration-150 ease-in-out #{t.input_focus}"
    end

    # @return [String] Navbar search input classes
    def cp_navbar_search_class
      "block w-full appearance-none #{t.border_radius} border #{t.input_border} #{t.navbar_search_bg} pl-10 pr-4 py-2 text-sm " \
        "#{t.body_text} shadow-sm outline-none transition duration-150 ease-in-out placeholder:text-gray-400 " \
        "#{t.input_focus} #{t.navbar_search_focus_bg}"
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
      "inline-flex items-center justify-center h-5 min-w-5 px-1 rounded-full #{t.badge_count} text-xs font-bold"
    end

    # @return [String] Filter apply button classes
    def cp_btn_filter_apply
      "inline-flex items-center px-3 #{t.border_radius} #{t.btn_primary} " \
        "text-sm font-medium transition duration-150 ease-in-out py-1.5"
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
      "#{t.sidebar_link} #{t.sidebar_link_hover}"
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
  end
end
