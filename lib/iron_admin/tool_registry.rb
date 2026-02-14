# frozen_string_literal: true

module IronAdmin
  class ToolRegistry
    class << self
      def register(tool_class)
        tools[tool_class.tool_name] = tool_class
      end

      def all
        tools.values
      end

      def find(tool_name)
        tools[tool_name.to_s]
      end

      def grouped
        all.group_by { |tool| tool.menu_options[:group] || "Tools" }
      end

      def sorted
        all.sort_by { |tool| tool.menu_options[:priority] || 999 }
      end

      def reset!
        @tools = {}
      end

      private

      def tools
        @tools ||= {}
      end
    end
  end
end
