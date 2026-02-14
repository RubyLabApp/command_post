# frozen_string_literal: true

module IronAdmin
  module Themes
    module Tailwind
      # Style defaults for UI component groups: button, badge, modal, alert,
      # dropdown, tooltip, pagination, empty_state.
      module Components
        def self.button
          {
            base: "inline-flex items-center justify-center gap-2 font-medium rounded-lg " \
                  "transition-colors duration-150 focus:outline-none focus:ring-2 " \
                  "focus:ring-offset-1 disabled:opacity-50 disabled:cursor-not-allowed",
            variants: {
              primary: "bg-indigo-600 text-white hover:bg-indigo-700 " \
                       "focus:ring-2 focus:ring-indigo-500/20 focus:ring-offset-1",
              secondary: "bg-white text-gray-700 border border-gray-300 " \
                         "hover:bg-gray-50 hover:border-gray-400",
              danger: "bg-red-600 text-white hover:bg-red-700",
              ghost: "bg-gray-100 text-gray-700 hover:bg-gray-200",
            },
            sizes: {
              sm: "px-3 py-1.5 text-sm",
              md: "px-4 py-2 text-sm",
              lg: "px-5 py-2.5 text-base",
            },
          }
        end

        def self.badge
          {
            base: "inline-flex items-center font-medium rounded-full",
            colors: {
              green: "bg-green-100 text-green-800",
              red: "bg-red-100 text-red-800",
              yellow: "bg-yellow-100 text-yellow-800",
              blue: "bg-blue-100 text-blue-800",
              indigo: "bg-indigo-100 text-indigo-800",
              purple: "bg-purple-100 text-purple-800",
              pink: "bg-pink-100 text-pink-800",
              orange: "bg-orange-100 text-orange-800",
              teal: "bg-teal-100 text-teal-800",
              gray: "bg-gray-100 text-gray-800",
            },
            sizes: {
              sm: "px-2 py-0.5 text-xs",
              md: "px-2.5 py-0.5 text-sm",
              lg: "px-3 py-1 text-sm",
            },
            count: "bg-indigo-600 text-white",
            count_base: "inline-flex items-center justify-center h-5 min-w-5 px-1 " \
                        "rounded-full text-xs font-bold",
          }
        end

        def self.modal
          {
            overlay: "fixed inset-0 bg-gray-500/75 transition-opacity",
            container: "fixed inset-0 z-50 overflow-y-auto",
            panel_base: "relative w-full",
            sizes: {
              sm: "max-w-md",
              md: "max-w-lg",
              lg: "max-w-2xl",
              xl: "max-w-4xl",
              full: "max-w-full mx-4",
            },
            close_button: "absolute top-4 right-4 text-gray-400 hover:text-gray-500",
            header: "px-6 py-4 border-b",
            body: "px-6 py-4",
            footer: "px-6 py-4 border-t bg-gray-50 flex justify-end gap-3",
          }
        end

        def self.alert
          {
            base: "border rounded-lg p-4",
            variants: {
              success: { bg: "bg-green-50", border: "border-green-200",
                         text: "text-green-800", icon: "check-circle", },
              error: { bg: "bg-red-50", border: "border-red-200",
                       text: "text-red-800", icon: "x-circle", },
              warning: { bg: "bg-yellow-50", border: "border-yellow-200",
                         text: "text-yellow-800", icon: "exclamation-triangle", },
              info: { bg: "bg-blue-50", border: "border-blue-200",
                      text: "text-blue-800", icon: "information-circle", },
            },
          }
        end

        def self.dropdown
          {
            panel: "absolute mt-2 origin-top border shadow-lg z-50",
            item_base: "flex items-center gap-2 w-full px-4 py-2 text-sm text-left " \
                       "transition-colors duration-150",
            item_default: "text-gray-700 hover:bg-gray-50",
            item_destructive: "text-red-600 hover:bg-red-50",
            divider: "border-t border-gray-100 my-1",
          }
        end

        def self.tooltip
          {
            base: "absolute px-2 py-1 text-xs font-medium text-white bg-gray-900 " \
                  "rounded whitespace-nowrap opacity-0 invisible " \
                  "group-hover:opacity-100 group-hover:visible " \
                  "transition-all duration-150 z-50",
            positions: {
              top: "bottom-full left-1/2 -translate-x-1/2 mb-2",
              bottom: "top-full left-1/2 -translate-x-1/2 mt-2",
              left: "right-full top-1/2 -translate-y-1/2 mr-2",
              right: "left-full top-1/2 -translate-y-1/2 ml-2",
            },
          }
        end

        def self.pagination
          {
            page_base: "px-3 py-2 text-sm font-medium border transition-colors duration-150",
            page_active: "bg-indigo-50 border-indigo-500 text-indigo-600 z-10",
            page_inactive_hover: "hover:bg-gray-50",
            nav_base: "relative inline-flex items-center px-3 py-2 text-sm font-medium " \
                      "border transition-colors duration-150",
            nav_disabled: "text-gray-300 cursor-not-allowed",
            nav_enabled_hover: "hover:bg-gray-50",
            info: "text-sm text-gray-700",
            view_wrapper: "flex items-center justify-between border-t px-4 py-3 sm:px-6",
            view_button: "relative inline-flex items-center rounded-md px-3 py-2 " \
                         "text-sm font-semibold ring-1 ring-inset ring-gray-300 " \
                         "hover:bg-gray-50 focus-visible:outline-offset-0",
            view_disabled: "relative inline-flex items-center rounded-md px-3 py-2 " \
                           "text-sm font-semibold text-gray-300 ring-1 ring-inset " \
                           "ring-gray-300 cursor-not-allowed",
          }
        end

        def self.empty_state
          {
            wrapper: "py-12 text-center",
            icon: "mx-auto h-12 w-12 text-gray-400",
            title: "mt-4 text-lg font-medium text-gray-900",
            description: "mt-2 text-sm text-gray-500",
            action: "mt-6",
          }
        end
      end
    end
  end
end
