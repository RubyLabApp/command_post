# frozen_string_literal: true

module IronAdmin
  module Themes
    module Tailwind
      # Style defaults for layout, sidebar, navbar, card, and typography groups.
      module Layout
        def self.layout
          {
            shell: "flex h-screen overflow-hidden",
            content_area: "flex-1 flex flex-col overflow-hidden",
            main_area: "flex-1 overflow-auto",
            page_wrapper: "p-8 max-w-7xl mx-auto",
            page_header: "flex items-center justify-between mb-6",
            main_bg: "bg-gray-50",
            body: "text-gray-900 antialiased",
            border_radius: "rounded-lg",
          }
        end

        def self.sidebar
          {
            nav: "w-64 flex flex-col h-full overflow-y-auto",
            bg: "bg-gray-900",
            title: "text-white",
            link: "text-gray-300",
            link_hover: "hover:bg-gray-800 hover:text-white",
            link_base: "flex items-center gap-3 px-3 py-2 rounded-lg",
            group_label: "text-gray-400",
            group_label_base: "px-3 text-xs font-semibold uppercase tracking-wider",
            logo_height: "h-8",
            section_padding: "p-6",
            nav_padding: "px-3",
          }
        end

        def self.navbar
          {
            wrapper: "px-6 py-3 flex items-center justify-between border-b",
            bg: "bg-white",
            border: "border-gray-200",
            search_bg: "bg-gray-50",
            search_focus_bg: "focus:bg-white",
            search_icon: "h-4 w-4 text-gray-400",
            user_text: "text-sm text-gray-600",
          }
        end

        def self.card
          {
            bg: "bg-white",
            border: "border-gray-200",
            shadow: "shadow",
            content_padding: "p-6",
            overflow: "overflow-hidden",
          }
        end

        def self.typography
          {
            font_family: "",
            heading_weight: "font-bold",
            body_text: "text-gray-900",
            muted_text: "text-gray-500",
            label_text: "text-gray-700",
          }
        end

        def self.link
          {
            primary: "text-indigo-600 hover:text-indigo-900",
            muted: "text-gray-500 hover:text-gray-700",
          }
        end

        def self.scope
          {
            base: "px-4 py-2 text-sm font-medium border-b-2 -mb-px " \
                  "transition-colors duration-150",
            active: "border-indigo-600 text-indigo-600",
            inactive: "border-transparent text-gray-500 hover:text-gray-700 " \
                      "hover:border-gray-300",
            container: "flex gap-1 border-b",
            wrapper: "flex items-center justify-between mb-4",
          }
        end
      end
    end
  end
end
