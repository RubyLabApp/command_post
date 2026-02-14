# frozen_string_literal: true

module IronAdmin
  module Ui
    # Renders a styled alert/notification message.
    #
    # @example Success alert
    #   render IronAdmin::Ui::AlertComponent.new(
    #     message: "Record saved successfully",
    #     type: :success
    #   )
    #
    # @example Error alert
    #   render IronAdmin::Ui::AlertComponent.new(
    #     message: "Something went wrong",
    #     type: :error
    #   )
    class AlertComponent < ViewComponent::Base
      # @return [String, nil] The alert message
      attr_reader :message

      # @return [Symbol] Alert type (:success, :error, :warning, :info)
      attr_reader :type

      # @return [Boolean] Whether alert can be dismissed
      attr_reader :dismissible

      # @api private
      # @return [IronAdmin::Configuration::Theme] Theme configuration
      def self.theme
        IronAdmin.configuration.theme
      end

      # @param message [String, nil] Alert message
      # @param type [Symbol] Alert type (default: :info)
      # @param dismissible [Boolean] Can be dismissed (default: true)
      def initialize(message: nil, type: :info, dismissible: true)
        @message = message
        @type = type.to_sym
        @dismissible = dismissible
      end

      # @api private
      # @return [Hash] Configuration for the current alert type
      def type_config
        variants = self.class.theme.alert.variants
        variants[@type] || variants[:info]
      end

      # @api private
      # @return [String] CSS classes for alert container
      def alert_classes
        "#{type_config[:bg]} #{type_config[:border]} #{type_config[:text]} #{self.class.theme.alert.base}"
      end

      # @api private
      # @return [String] Heroicon name for alert type
      def icon_name
        type_config[:icon]
      end

      # @api private
      # @return [Boolean] Whether to render the component
      def render?
        message.present? || content.present?
      end
    end
  end
end
