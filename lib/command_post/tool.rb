# frozen_string_literal: true

module CommandPost
  class Tool
    class_attribute :menu_options, default: {}

    class << self
      def inherited(subclass)
        super
        return if subclass.name.nil?

        begin
          CommandPost::ToolRegistry.register(subclass)
        rescue NameError
          # ToolRegistry may not be loaded yet during boot
        end
      end

      def menu(**options)
        self.menu_options = options
      end

      def tool_name
        name.sub(/Tool\z/, "").demodulize.underscore
      end

      def label
        menu_options[:label] || tool_name.humanize
      end
    end
  end
end
