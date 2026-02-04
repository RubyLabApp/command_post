module CommandPost
  module UI
    class ButtonComponent < ViewComponent::Base
      attr_reader :text, :variant, :size, :icon, :href, :method, :confirm, :disabled, :type

      VARIANTS = {
        primary: -> { CommandPost.configuration.theme.btn_primary },
        secondary: -> { CommandPost.configuration.theme.btn_secondary },
        danger: -> { CommandPost.configuration.theme.btn_danger },
        ghost: -> { CommandPost.configuration.theme.btn_ghost },
      }.freeze

      SIZES = {
        sm: "px-3 py-1.5 text-sm",
        md: "px-4 py-2 text-sm",
        lg: "px-5 py-2.5 text-base",
      }.freeze

      def initialize(text: nil, variant: :primary, size: :md, icon: nil, href: nil,
                     method: nil, confirm: nil, disabled: false, type: :button)
        @text = text
        @variant = variant.to_sym
        @size = size.to_sym
        @icon = icon
        @href = href
        @method = method
        @confirm = confirm
        @disabled = disabled
        @type = type
      end

      def variant_classes
        variant_proc = VARIANTS[@variant] || VARIANTS[:primary]
        variant_proc.call
      end

      def size_classes
        SIZES[@size] || SIZES[:md]
      end

      def base_classes
        "inline-flex items-center justify-center gap-2 font-medium rounded-lg transition-colors duration-150 " \
          "focus:outline-none focus:ring-2 focus:ring-offset-1 disabled:opacity-50 disabled:cursor-not-allowed"
      end

      def button_classes
        "#{base_classes} #{variant_classes} #{size_classes}"
      end

      def data_attributes
        data = {}
        data[:turbo_method] = method if method
        data[:turbo_confirm] = confirm if confirm
        data
      end

      def call
        if href
          link_to(href, class: button_classes, data: data_attributes) do
            button_content
          end
        else
          tag.button(type: type, class: button_classes, disabled: disabled, data: data_attributes) do
            button_content
          end
        end
      end

      private

      def button_content
        safe_join([icon_element, text_element].compact)
      end

      def icon_element
        return unless icon

        helpers.heroicon(icon, variant: :outline, options: { class: "h-5 w-5" })
      end

      def text_element
        return unless text || content

        content || text
      end
    end
  end
end
