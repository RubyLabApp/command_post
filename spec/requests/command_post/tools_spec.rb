# frozen_string_literal: true

require "rails_helper"

# Define a test tool for specs
class SampleTool < CommandPost::Tool
  menu icon: "wrench", label: "Sample Tool", priority: 1, group: "Utilities"
end

RSpec.describe "Custom tools", type: :request do
  before do
    CommandPost::ResourceRegistry.register(UserResource)
    CommandPost::ToolRegistry.register(SampleTool)
  end

  describe "GET /tools/:tool_name" do
    it "renders the tool page" do
      get tool_path("sample")
      expect(response).to have_http_status(:ok)
    end

    it "returns 404 for unknown tool" do
      get tool_path("nonexistent")
      expect(response).to have_http_status(:not_found)
    end

    it "includes tool label in page" do
      get tool_path("sample")
      expect(response.body).to include("Sample Tool")
    end
  end
end
