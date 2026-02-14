# frozen_string_literal: true

module IronAdmin
  module Ui
    # Renders a modal dialog overlay.
    #
    # @example Basic modal
    #   render IronAdmin::Ui::ModalComponent.new do |modal|
    #     modal.with_title { "Confirm Action" }
    #     "Are you sure?"
    #     modal.with_footer { render ButtonComponent.new(text: "Confirm") }
    #   end
    class ModalComponent < ViewComponent::Base
      renders_one :title
      renders_one :footer

      # @return [Symbol] Modal size (:sm, :md, :lg, :xl, :full)
      attr_reader :size

      # @return [Boolean] Whether modal can be dismissed
      attr_reader :dismissible

      # @param size [Symbol] Modal size (default: :md)
      # @param dismissible [Boolean] Can be dismissed (default: true)
      def initialize(size: :md, dismissible: true)
        @size = size.to_sym
        @dismissible = dismissible
      end

      # @api private
      # @return [IronAdmin::Configuration::Theme] Theme configuration
      def theme
        IronAdmin.configuration.theme
      end

      # @api private
      # @return [String] CSS classes for modal size
      def size_classes
        sizes = theme.modal.sizes
        sizes[@size] || sizes[:md]
      end

      # @api private
      # @return [String] CSS classes for modal container
      def modal_classes
        "relative #{theme.card_bg} #{theme.border_radius} #{theme.card_shadow}-xl w-full #{size_classes}"
      end
    end
  end
end
