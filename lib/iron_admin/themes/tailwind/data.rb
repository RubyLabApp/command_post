# frozen_string_literal: true

module IronAdmin
  module Themes
    module Tailwind
      # Style defaults for data-oriented groups: form, table, chart, display.
      module Data
        CHECKBOX_SVG =
          "checked:bg-[url('data:image/svg+xml;charset=utf-8," \
          "%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20" \
          "viewBox%3D%220%200%2020%2020%22%20fill%3D%22white%22%3E%3Cpath%20" \
          "fill-rule%3D%22evenodd%22%20d%3D%22M16.707%205.293a1%201%200%20010%20" \
          "1.414l-8%208a1%201%200%2001-1.414%200l-4-4a1%201%200%20011.414-1.414" \
          "L8%2012.586l7.293-7.293a1%201%200%20011.414%200z%22%20clip-rule%3D%22" \
          "evenodd%22%2F%3E%3C%2Fsvg%3E')] " \
          "bg-[length:100%_100%] bg-center bg-no-repeat"

        SELECT_SVG =
          "bg-[url('data:image/svg+xml;charset=utf-8," \
          "%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20" \
          "viewBox%3D%220%200%2020%2020%22%20fill%3D%22%236b7280%22%3E%3Cpath%20" \
          "fill-rule%3D%22evenodd%22%20d%3D%22M5.23%207.21a.75.75%200%20011.06.02" \
          "L10%2011.168l3.71-3.938a.75.75%200%20111.08%201.04l-4.25%204.5a.75.75" \
          "%200%2001-1.08%200l-4.25-4.5a.75.75%200%2001.02-1.06z%22%20" \
          "clip-rule%3D%22evenodd%22%2F%3E%3C%2Fsvg%3E')] " \
          "bg-[length:1.25rem_1.25rem] bg-[position:right_0.5rem_center] bg-no-repeat"

        # Inline CSS style for select chevron dropdown arrow.
        SELECT_CHEVRON_STYLE =
          "background-image: url(\"data:image/svg+xml," \
          "%3csvg xmlns='http://www.w3.org/2000/svg' fill='none' " \
          "viewBox='0 0 20 20'%3e%3cpath stroke='%236b7280' " \
          "stroke-linecap='round' stroke-linejoin='round' " \
          "stroke-width='1.5' d='M6 8l4 4 4-4'/%3e%3c/svg%3e\"); " \
          "background-position: right 0.5rem center; " \
          "background-repeat: no-repeat; " \
          "background-size: 1.5em 1.5em; padding-right: 2.5rem;"

        def self.form
          form_input_tokens.merge(form_ui_tokens)
        end

        def self.form_input_tokens
          {
            input_base: "block w-full border px-3 py-2 text-sm " \
                        "shadow-sm outline-none transition duration-150 ease-in-out",
            input_border: "border-gray-300 hover:border-gray-400",
            input_focus: "focus:border-indigo-500 focus:ring-2 focus:ring-indigo-500/20",
            focus_ring: "focus:border-indigo-500 focus:ring-2 focus:ring-indigo-500/20",
            error_border: "!border-red-400 !focus:border-red-500 !focus:ring-red-500/20",
            disabled: "bg-gray-50 cursor-not-allowed",
            placeholder: "placeholder:text-gray-400",
            checkbox_base: "h-4 w-4 rounded border-gray-300 text-indigo-600 " \
                           "transition duration-150 ease-in-out",
            checkbox_checked: "checked:border-indigo-600 checked:bg-indigo-600 " \
                              "focus:ring-2 focus:ring-indigo-500/20",
            select_extra: "appearance-none pr-10",
            textarea_extra: "resize-y",
            filter_input: "block w-full appearance-none border px-3 py-2 text-sm " \
                          "shadow-sm outline-none transition duration-150 ease-in-out",
            search_input: "block w-full appearance-none border pl-10 pr-4 py-2 text-sm " \
                          "shadow-sm outline-none transition duration-150 ease-in-out",
            file_input: "block w-full text-sm file:mr-4 file:py-2 file:px-4 " \
                        "file:rounded-lg file:border-0 file:text-sm file:font-medium " \
                        "file:bg-gray-100 file:text-gray-700 hover:file:bg-gray-200 " \
                        "file:cursor-pointer cursor-pointer",
          }
        end

        def self.form_ui_tokens
          {
            checkbox_svg: CHECKBOX_SVG,
            select_svg: SELECT_SVG,
            select_chevron_style: SELECT_CHEVRON_STYLE,
            label: "block text-sm font-medium",
            label_margin: "mb-1.5",
            error_icon: "h-4 w-4 text-red-500 shrink-0",
            error_text: "text-sm text-red-600",
            error_container: "flex items-center gap-1.5 mt-1.5",
            required_indicator: "text-red-500",
            wrapper_span_full: "md:col-span-2 2xl:col-span-3",
            search_hint: "text-xs mt-1 italic",
            autocomplete_item: "px-3 py-2 text-sm cursor-pointer hover:bg-gray-100",
            autocomplete_no_results: "px-3 py-2 text-sm",
            autocomplete_highlight: "bg-gray-100",
            autocomplete_panel: "absolute z-50 mt-1 w-full max-h-60 overflow-auto shadow-lg",
            grid: "grid grid-cols-1 md:grid-cols-2 2xl:grid-cols-3 gap-x-6 gap-y-5",
            actions: "flex items-center gap-3 mt-8 pt-6 border-t",
            color_picker: "h-10 w-14 rounded border border-gray-300 cursor-pointer p-0.5",
            currency_symbol: "pointer-events-none absolute inset-y-0 left-0 " \
                             "flex items-center pl-3 text-sm",
            tag_chip: "inline-flex items-center gap-1 px-2 py-1 text-sm rounded-full",
            tag_remove: "ml-1",
            file_preview: "flex items-center gap-3 mb-2 p-3 rounded-lg border",
            boolean_wrapper: "flex items-center pt-1 gap-2.5",
          }
        end

        def self.table
          {
            wrapper: "min-w-full divide-y",
            header_bg: "bg-gray-50",
            header_cell: "px-6 py-3 text-left text-xs font-medium text-gray-500 " \
                         "uppercase tracking-wider",
            body_cell: "px-6 py-4 whitespace-nowrap text-sm",
            row_hover: "hover:bg-gray-50",
            border: "divide-gray-200",
            sort_icon: "h-4 w-4 text-gray-400",
            sort_icon_active: "h-4 w-4 text-indigo-500",
            sort_icon_inactive: "h-3.5 w-3.5 opacity-0 group-hover:opacity-50 " \
                                "transition-opacity",
            sort_link: "inline-flex items-center gap-1 group",
            checkbox_cell: "px-6 py-3 w-4",
            checkbox_input: "rounded border-gray-300",
            empty_cell: "px-6 py-8 text-center text-sm",
            actions_cell: "whitespace-nowrap text-right text-sm px-6 py-4",
            sticky_shadow: "shadow-[-4px_0_6px_-4px_rgba(0,0,0,0.08)]",
            bulk_bar: "hidden items-center gap-3 mb-4 px-4 py-3 border",
            bulk_button: "px-3 py-1.5 text-sm font-medium rounded-lg " \
                         "inline-flex items-center gap-1",
          }
        end

        def self.chart
          {
            colors: %w[
              rgba(99,102,241,0.8) rgba(59,130,246,0.8) rgba(16,185,129,0.8)
              rgba(245,158,11,0.8) rgba(239,68,68,0.8) rgba(139,92,246,0.8)
            ],
            border_color: "rgb(99, 102, 241)",
          }
        end
      end
    end
  end
end
