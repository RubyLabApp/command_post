module CommandPost
  module ThemeHelper
    def t
      CommandPost.configuration.theme
    end

    def cp_btn_primary
      "inline-flex items-center px-4 py-2 #{t.border_radius} #{t.btn_primary} " \
        "transition duration-150 ease-in-out"
    end

    def cp_btn_primary_lg
      "inline-flex items-center px-5 text-sm font-medium #{t.border_radius} shadow-sm " \
        "#{t.btn_primary} transition duration-150 ease-in-out cursor-pointer py-2.5"
    end

    def cp_btn_secondary
      "inline-flex items-center px-5 text-sm font-medium #{t.border_radius} shadow-sm " \
        "#{t.btn_secondary} transition duration-150 ease-in-out py-2.5"
    end

    def cp_btn_danger
      "px-4 py-2 #{t.border_radius} #{t.btn_danger}"
    end

    def cp_btn_ghost
      "inline-flex items-center gap-2 px-4 py-2 #{t.border_radius} #{t.btn_ghost}"
    end

    def cp_link
      t.link
    end

    def cp_link_muted
      t.link_muted
    end

    def cp_focus
      t.input_focus
    end

    def cp_input_class
      "block w-full appearance-none #{t.border_radius} border #{t.input_border} #{t.card_bg} px-3.5 py-2.5 text-sm " \
        "#{t.body_text} shadow-sm outline-none placeholder:text-gray-400 transition duration-150 ease-in-out #{t.input_focus}"
    end

    def cp_select_class
      "block w-full appearance-none #{t.border_radius} border #{t.input_border} #{t.card_bg} px-3.5 py-2.5 pr-10 text-sm " \
        "#{t.body_text} shadow-sm outline-none transition duration-150 ease-in-out #{t.input_focus} " \
        "bg-[url('data:image/svg+xml;charset=utf-8,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20" \
        "viewBox%3D%220%200%2020%2020%22%20fill%3D%22%236b7280%22%3E%3Cpath%20fill-rule%3D%22evenodd%22%20d%3D%22" \
        "M5.23%207.21a.75.75%200%20011.06.02L10%2011.168l3.71-3.938a.75.75%200%20111.08%201.04l-4.25%204.5a.75.75" \
        "%200%2001-1.08%200l-4.25-4.5a.75.75%200%2001.02-1.06z%22%20clip-rule%3D%22evenodd%22%2F%3E%3C%2Fsvg%3E')] " \
        "bg-[length:1.25rem_1.25rem] bg-[position:right_0.5rem_center] bg-no-repeat"
    end

    def cp_textarea_class
      "block w-full appearance-none #{t.border_radius} border #{t.input_border} #{t.card_bg} px-3.5 py-2.5 text-sm " \
        "#{t.body_text} shadow-sm outline-none placeholder:text-gray-400 transition duration-150 ease-in-out " \
        "#{t.input_focus} resize-y"
    end

    def cp_checkbox_class
      "h-4.5 w-4.5 appearance-none rounded border #{t.input_border} #{t.card_bg} shadow-sm transition duration-150 " \
        "ease-in-out #{t.checkbox_checked} " \
        "checked:bg-[url('data:image/svg+xml;charset=utf-8,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg" \
        "%22%20viewBox%3D%220%200%2020%2020%22%20fill%3D%22white%22%3E%3Cpath%20fill-rule%3D%22evenodd%22%20d%3D%22" \
        "M16.707%205.293a1%201%200%20010%201.414l-8%208a1%201%200%2001-1.414%200l-4-4a1%201%200%20011.414-1.414L8" \
        "%2012.586l7.293-7.293a1%201%200%20011.414%200z%22%20clip-rule%3D%22evenodd%22%2F%3E%3C%2Fsvg%3E')] " \
        "bg-[length:100%_100%] bg-center bg-no-repeat focus:ring-offset-1 cursor-pointer"
    end

    def cp_filter_input_class
      "block w-full appearance-none #{t.border_radius} border #{t.input_border} #{t.card_bg} px-3 py-2 text-sm " \
        "#{t.body_text} shadow-sm outline-none transition duration-150 ease-in-out #{t.input_focus}"
    end

    def cp_search_class
      "block w-full appearance-none #{t.border_radius} border #{t.input_border} #{t.card_bg} pl-10 pr-4 py-2 text-sm " \
        "#{t.body_text} shadow-sm outline-none placeholder:text-gray-400 transition duration-150 ease-in-out #{t.input_focus}"
    end

    def cp_navbar_search_class
      "block w-full appearance-none #{t.border_radius} border #{t.input_border} #{t.navbar_search_bg} pl-10 pr-4 py-2 text-sm " \
        "#{t.body_text} shadow-sm outline-none transition duration-150 ease-in-out placeholder:text-gray-400 " \
        "#{t.input_focus} #{t.navbar_search_focus_bg}"
    end

    def cp_scope_active
      t.scope_active
    end

    def cp_scope_inactive
      t.scope_inactive
    end

    def cp_badge_count
      "inline-flex items-center justify-center h-5 min-w-5 px-1 rounded-full #{t.badge_count} text-xs font-bold"
    end

    def cp_btn_filter_apply
      "inline-flex items-center px-3 #{t.border_radius} #{t.btn_primary} " \
        "text-sm font-medium transition duration-150 ease-in-out py-1.5"
    end

    def cp_sidebar_bg
      t.sidebar_bg
    end

    def cp_sidebar_title
      t.sidebar_title
    end

    def cp_sidebar_link
      "#{t.sidebar_link} #{t.sidebar_link_hover}"
    end

    def cp_sidebar_group_label
      t.sidebar_group_label
    end

    def cp_heading
      "#{t.heading_weight} #{t.font_family}".strip
    end

    def cp_card
      "#{t.card_bg} #{t.border_radius} #{t.card_shadow}"
    end

    def cp_body_text
      t.body_text
    end

    def cp_muted_text
      t.muted_text
    end

    def cp_label_text
      t.label_text
    end

    def cp_table_header_bg
      t.table_header_bg
    end

    def cp_table_row_hover
      t.table_row_hover
    end

    def cp_table_border
      t.table_border
    end
  end
end
