# frozen_string_literal: true

module IronAdmin
  module Ui
    # Renders a styled button or link styled as a button.
    #
    # @example Primary button
    #   render IronAdmin::Ui::ButtonComponent.new(text: "Save")
    #
    # @example Danger button with confirmation
    #   render IronAdmin::Ui::ButtonComponent.new(
    #     text: "Delete",
    #     variant: :danger,
    #     confirm: "Are you sure?"
    #   )
    #
    # @example Link styled as button
    #   render IronAdmin::Ui::ButtonComponent.new(
    #     text: "View",
    #     href: user_path(@user),
    #     variant: :secondary
    #   )
    class ButtonComponent < ViewComponent::Base
      # @return [String, nil] Button text
      attr_reader :text

      # @return [Symbol] Style variant (:primary, :secondary, :danger, :ghost)
      attr_reader :variant

      # @return [Symbol] Size variant (:sm, :md, :lg)
      attr_reader :size

      # @return [String, nil] Heroicon name
      attr_reader :icon

      # @return [String, nil] URL (renders as link if present)
      attr_reader :href

      # @return [Symbol, nil] HTTP method for Turbo
      attr_reader :method

      # @return [String, nil] Confirmation message
      attr_reader :confirm

      # @return [Boolean] Whether button is disabled
      attr_reader :disabled

      # @return [Symbol] Button type (:button, :submit)
      attr_reader :type

      # @api private
      # @return [IronAdmin::Configuration::Theme] Theme configuration
      def self.theme
        IronAdmin.configuration.theme
      end

      # @param text [String, nil] Button text
      # @param variant [Symbol] Style variant (default: :primary)
      # @param size [Symbol] Size variant (default: :md)
      # @param icon [String, nil] Heroicon name
      # @param href [String, nil] URL for link buttons
      # @param method [Symbol, nil] HTTP method
      # @param confirm [String, nil] Confirmation message
      # @param disabled [Boolean] Disabled state
      # @param type [Symbol] Button type (default: :button)
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

      # @api private
      # @return [String] CSS classes for button variant
      def variant_classes
        variants = self.class.theme.button.variants
        variants[@variant] || variants[:primary]
      end

      # @api private
      # @return [String] CSS classes for button size
      def size_classes
        sizes = self.class.theme.button.sizes
        sizes[@size] || sizes[:md]
      end

      # @api private
      # @return [String] Base CSS classes for all button variants
      def base_classes
        self.class.theme.button.base
      end

      # @api private
      # @return [String] Combined CSS classes for button
      def button_classes
        "#{base_classes} #{variant_classes} #{size_classes}"
      end

      # @api private
      # @return [Hash] Data attributes for Turbo
      def data_attributes
        data = {}
        data[:turbo_method] = method if method
        data[:turbo_confirm] = confirm if confirm
        data
      end

      # Renders the button or link.
      # @return [String] HTML content
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
