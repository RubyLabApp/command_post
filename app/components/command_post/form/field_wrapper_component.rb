module CommandPost
  module Form
    class FieldWrapperComponent < ViewComponent::Base
      attr_reader :name, :label, :errors, :required, :hint, :span_full

      def initialize(name:, label: nil, errors: [], required: false, hint: nil, span_full: false)
        @name = name
        @label = label || name.to_s.humanize
        @errors = Array(errors)
        @required = required
        @hint = hint
        @span_full = span_full
      end

      def theme
        CommandPost.configuration.theme
      end

      def has_errors?
        errors.any?
      end

      def wrapper_classes
        span_full ? "md:col-span-2 2xl:col-span-3" : ""
      end

      def label_classes
        "block text-sm font-medium #{theme.label_text} mb-1.5"
      end

      def error_classes
        "flex items-center gap-1.5 mt-1.5"
      end
    end
  end
end
