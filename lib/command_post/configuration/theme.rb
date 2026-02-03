module CommandPost
  class Configuration
    class Theme
      # --- Buttons ---
      attr_accessor :btn_primary, :btn_secondary, :btn_danger, :btn_ghost

      # --- Links ---
      attr_accessor :link, :link_muted

      # --- Focus ring ---
      attr_accessor :focus_ring

      # --- Inputs ---
      attr_accessor :input_border, :input_focus

      # --- Checkbox ---
      attr_accessor :checkbox_checked

      # --- Scopes / Tabs ---
      attr_accessor :scope_active, :scope_inactive

      # --- Badge counter ---
      attr_accessor :badge_count

      # --- Sidebar ---
      attr_accessor :sidebar_bg, :sidebar_title, :sidebar_link, :sidebar_link_hover,
                    :sidebar_group_label

      # --- Navbar ---
      attr_accessor :navbar_bg, :navbar_border, :navbar_search_bg, :navbar_search_focus_bg

      # --- Table ---
      attr_accessor :table_header_bg, :table_row_hover, :table_border

      # --- Cards / Panels ---
      attr_accessor :card_bg, :card_border, :card_shadow

      # --- Typography ---
      attr_accessor :font_family, :heading_weight, :body_text, :muted_text, :label_text

      # --- Layout ---
      attr_accessor :border_radius

      def initialize
        # --- Buttons ---
        @btn_primary = "bg-indigo-600 text-white hover:bg-indigo-700 focus:ring-2 focus:ring-indigo-500/20 focus:ring-offset-1"
        @btn_secondary = "bg-white text-gray-700 border border-gray-300 hover:bg-gray-50 hover:border-gray-400"
        @btn_danger = "bg-red-600 text-white hover:bg-red-700"
        @btn_ghost = "bg-gray-100 text-gray-700 hover:bg-gray-200"

        # --- Links ---
        @link = "text-indigo-600 hover:text-indigo-900"
        @link_muted = "text-gray-500 hover:text-gray-700"

        # --- Focus ring ---
        @focus_ring = "focus:border-indigo-500 focus:ring-2 focus:ring-indigo-500/20"

        # --- Inputs ---
        @input_border = "border-gray-300 hover:border-gray-400"
        @input_focus = "focus:border-indigo-500 focus:ring-2 focus:ring-indigo-500/20"

        # --- Checkbox ---
        @checkbox_checked = "checked:border-indigo-600 checked:bg-indigo-600 focus:ring-2 focus:ring-indigo-500/20"

        # --- Scopes / Tabs ---
        @scope_active = "border-indigo-600 text-indigo-600"
        @scope_inactive = "border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300"

        # --- Badge counter ---
        @badge_count = "bg-indigo-600 text-white"

        # --- Sidebar ---
        @sidebar_bg = "bg-gray-900"
        @sidebar_title = "text-white"
        @sidebar_link = "text-gray-300"
        @sidebar_link_hover = "hover:bg-gray-800 hover:text-white"
        @sidebar_group_label = "text-gray-400"

        # --- Navbar ---
        @navbar_bg = "bg-white"
        @navbar_border = "border-gray-200"
        @navbar_search_bg = "bg-gray-50"
        @navbar_search_focus_bg = "focus:bg-white"

        # --- Table ---
        @table_header_bg = "bg-gray-50"
        @table_row_hover = "hover:bg-gray-50"
        @table_border = "divide-gray-200"

        # --- Cards / Panels ---
        @card_bg = "bg-white"
        @card_border = "border-gray-200"
        @card_shadow = "shadow"

        # --- Typography ---
        @font_family = ""
        @heading_weight = "font-bold"
        @body_text = "text-gray-900"
        @muted_text = "text-gray-500"
        @label_text = "text-gray-700"

        # --- Layout ---
        @border_radius = "rounded-lg"
      end
    end
  end
end
