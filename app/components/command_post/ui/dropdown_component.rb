module CommandPost
  module UI
    class DropdownComponent < ViewComponent::Base
      renders_one :trigger
      renders_many :items, "ItemComponent"

      attr_reader :align, :width

      def initialize(align: :right, width: 48)
        @align = align
        @width = width
      end

      def theme
        CommandPost.configuration.theme
      end

      def dropdown_classes
        align_class = align == :right ? "right-0" : "left-0"
        width_class = "w-#{width}"
        "absolute #{align_class} mt-2 #{width_class} origin-top-#{align} #{theme.border_radius} " \
          "#{theme.card_bg} border #{theme.card_border} #{theme.card_shadow}-lg z-50"
      end

      class ItemComponent < ViewComponent::Base
        attr_reader :href, :method, :icon, :destructive

        def initialize(href: nil, method: nil, icon: nil, destructive: false)
          @href = href
          @method = method
          @icon = icon
          @destructive = destructive
        end

        def item_classes
          base = "flex items-center gap-2 w-full px-4 py-2 text-sm text-left transition-colors duration-150"
          if destructive
            "#{base} text-red-600 hover:bg-red-50"
          else
            "#{base} text-gray-700 hover:bg-gray-50"
          end
        end

        def call
          if href
            link_to(href, class: item_classes, data: method ? { turbo_method: method } : {}) do
              item_content
            end
          else
            tag.button(type: "button", class: item_classes) do
              item_content
            end
          end
        end

        private

        def item_content
          safe_join([icon_element, content].compact)
        end

        def icon_element
          return unless icon

          helpers.heroicon(icon, variant: :outline, options: { class: "h-4 w-4" })
        end
      end
    end
  end
end
