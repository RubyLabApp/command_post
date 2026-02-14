# frozen_string_literal: true

module IronAdmin
  module Themes
    module Tailwind
      # Style defaults for view-oriented groups: filter, display, audit.
      module Views
        def self.filter
          {
            label: "block text-xs font-semibold uppercase tracking-wider",
            trigger: "inline-flex items-center gap-2 px-4 cursor-pointer " \
                     "select-none text-sm font-medium border shadow-sm " \
                     "transition duration-150 py-2.5 hover:bg-gray-50",
            panel: "absolute right-0 top-full mt-2 w-72 border z-20",
            chevron_icon: "h-4 w-4 transition-transform group-open:rotate-180",
            actions_bar: "flex items-center gap-3 mt-4 pt-3 border-t border-gray-100",
            wrapper: "flex justify-end mb-4",
          }
        end

        def self.display
          {
            boolean_true: "h-5 w-5 text-green-500",
            boolean_false: "h-5 w-5 text-red-400",
            password: "text-gray-400 tracking-wider",
            tags_base: "flex flex-wrap gap-1",
            tag: "inline-flex px-2 py-0.5 text-xs font-medium rounded-full " \
                 "bg-indigo-50 text-indigo-700",
            files_wrapper: "flex flex-wrap gap-2",
            file_image: "h-16 w-16 object-cover rounded",
            file_image_small: "h-12 w-12 object-cover rounded",
            file_attachment: "inline-flex items-center px-2 py-1 text-xs rounded " \
                             "bg-gray-100 text-gray-700",
            color_swatch: "inline-block h-5 w-5 rounded border border-gray-300",
            prose: "prose prose-sm max-w-none",
            detail_row: "px-6 py-4 flex items-center",
            detail_row_sm: "px-6 py-3 flex items-center",
            detail_term: "text-sm font-medium w-1/3",
            detail_value: "text-sm w-2/3",
            chip_link: "inline-flex px-3 py-1 text-sm font-medium rounded-full " \
                       "hover:bg-indigo-100 transition-colors",
            chip_static: "inline-flex px-3 py-1 text-sm font-medium rounded-full " \
                         "bg-gray-100 text-gray-700",
            search_result: "block px-6 py-4 text-sm",
          }
        end

        def self.audit
          {
            diff_bg: "text-xs font-mono bg-gray-50 p-2 rounded max-w-md overflow-auto",
            diff_removed: "text-red-600 line-through",
            diff_added: "text-green-600",
          }
        end
      end
    end
  end
end
