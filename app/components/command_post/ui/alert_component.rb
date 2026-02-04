module CommandPost
  module UI
    class AlertComponent < ViewComponent::Base
      attr_reader :message, :type, :dismissible

      TYPES = {
        success: {
          bg: "bg-green-50",
          border: "border-green-200",
          text: "text-green-800",
          icon: "check-circle",
        },
        error: {
          bg: "bg-red-50",
          border: "border-red-200",
          text: "text-red-800",
          icon: "x-circle",
        },
        warning: {
          bg: "bg-yellow-50",
          border: "border-yellow-200",
          text: "text-yellow-800",
          icon: "exclamation-triangle",
        },
        info: {
          bg: "bg-blue-50",
          border: "border-blue-200",
          text: "text-blue-800",
          icon: "information-circle",
        },
      }.freeze

      def initialize(message: nil, type: :info, dismissible: true)
        @message = message
        @type = type.to_sym
        @dismissible = dismissible
      end

      def type_config
        TYPES[@type] || TYPES[:info]
      end

      def alert_classes
        "#{type_config[:bg]} #{type_config[:border]} #{type_config[:text]} border rounded-lg p-4"
      end

      def icon_name
        type_config[:icon]
      end

      def render?
        message.present? || content.present?
      end
    end
  end
end
