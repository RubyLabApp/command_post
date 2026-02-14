# frozen_string_literal: true

module IronAdmin
  class ToolsController < ApplicationController
    before_action :set_tool

    def show; end

    def execute
      action = params[:action_name]
      return head(:not_found) unless @tool_class.method_defined?(action)

      tool_instance = @tool_class.new
      tool_instance.public_send(action)
      redirect_to tool_path(@tool_class.tool_name)
    end

    private

    def set_tool
      @tool_class = ToolRegistry.find(params[:tool_name])
      head(:not_found) and return unless @tool_class
    end
  end
end
