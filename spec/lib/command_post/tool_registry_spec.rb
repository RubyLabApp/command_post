# frozen_string_literal: true

require "rails_helper"

RSpec.describe CommandPost::ToolRegistry do
  before { described_class.reset! }

  describe ".register" do
    it "registers a tool class" do
      tool_class = Class.new(CommandPost::Tool) do
        def self.name = "TestTool"
      end
      described_class.register(tool_class)

      expect(described_class.all).to include(tool_class)
    end
  end

  describe ".find" do
    it "finds a tool by name" do
      tool_class = Class.new(CommandPost::Tool) do
        def self.name = "ImportTool"
      end
      described_class.register(tool_class)

      expect(described_class.find("import")).to eq(tool_class)
    end

    it "returns nil for unknown tool" do
      expect(described_class.find("nonexistent")).to be_nil
    end
  end

  describe ".grouped" do
    it "groups tools by menu group" do
      tool_class = Class.new(CommandPost::Tool) do
        def self.name = "ImportTool"
      end
      tool_class.menu group: "Utilities"
      described_class.register(tool_class)

      expect(described_class.grouped.keys).to include("Utilities")
    end
  end

  describe ".reset!" do
    it "clears all registrations" do
      tool_class = Class.new(CommandPost::Tool) do
        def self.name = "TestTool"
      end
      described_class.register(tool_class)
      described_class.reset!

      expect(described_class.all).to be_empty
    end
  end
end
