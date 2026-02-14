# frozen_string_literal: true

require "rails_helper"

RSpec.describe IronAdmin::Tool do
  before { IronAdmin::ToolRegistry.reset! }

  describe ".tool_name" do
    it "derives name from class" do
      tool_class = Class.new(described_class) do
        def self.name = "ImportTool"
      end

      expect(tool_class.tool_name).to eq("import")
    end
  end

  describe ".menu" do
    it "stores menu options" do
      tool_class = Class.new(described_class) do
        def self.name = "ImportTool"
      end
      tool_class.menu icon: "arrow-up-tray", label: "Import Data", priority: 10

      expect(tool_class.menu_options[:icon]).to eq("arrow-up-tray")
      expect(tool_class.menu_options[:label]).to eq("Import Data")
      expect(tool_class.menu_options[:priority]).to eq(10)
    end
  end

  describe ".label" do
    context "when menu label is set" do
      it "returns the custom label" do
        tool_class = Class.new(described_class) do
          def self.name = "ImportTool"
        end
        tool_class.menu label: "Custom Label"

        expect(tool_class.label).to eq("Custom Label")
      end
    end

    context "when no menu label" do
      it "returns humanized tool name" do
        tool_class = Class.new(described_class) do
          def self.name = "ImportTool"
        end

        expect(tool_class.label).to eq("Import")
      end
    end
  end
end
