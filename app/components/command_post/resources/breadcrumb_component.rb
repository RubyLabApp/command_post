module CommandPost
  module Resources
    class BreadcrumbComponent < ViewComponent::Base
      renders_many :items, "ItemComponent"

      def theme
        CommandPost.configuration.theme
      end

      class ItemComponent < ViewComponent::Base
        attr_reader :label, :href, :current

        def initialize(label:, href: nil, current: false)
          @label = label
          @href = href
          @current = current
        end

        def theme
          CommandPost.configuration.theme
        end

        def item_classes
          if current
            "text-sm font-medium #{theme.body_text}"
          else
            "text-sm #{theme.link}"
          end
        end

        def call
          if href && !current
            link_to(label, href, class: item_classes)
          else
            tag.span(label, class: item_classes, aria: current ? { current: "page" } : {})
          end
        end
      end
    end
  end
end
