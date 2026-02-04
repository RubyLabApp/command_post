require "rails_helper"
require_relative "../../../../app/components/command_post/ui/empty_state_component"

RSpec.describe CommandPost::UI::EmptyStateComponent, type: :component do
  describe "#initialize" do
    it "has default title" do
      component = described_class.new
      expect(component.title).to eq("No results found")
    end

    it "has default icon" do
      component = described_class.new
      expect(component.icon).to eq("inbox")
    end

    it "accepts custom title" do
      component = described_class.new(title: "No users")
      expect(component.title).to eq("No users")
    end

    it "accepts description" do
      component = described_class.new(description: "Create your first user")
      expect(component.description).to eq("Create your first user")
    end

    it "accepts action_text and action_href" do
      component = described_class.new(action_text: "Create", action_href: "/new")
      expect(component.action_text).to eq("Create")
      expect(component.action_href).to eq("/new")
    end
  end

  describe "#has_action?" do
    it "returns true when both action_text and action_href are present" do
      component = described_class.new(action_text: "Create", action_href: "/new")
      expect(component.has_action?).to be true
    end

    it "returns false when action_text is missing" do
      component = described_class.new(action_href: "/new")
      expect(component.has_action?).to be false
    end

    it "returns false when action_href is missing" do
      component = described_class.new(action_text: "Create")
      expect(component.has_action?).to be false
    end
  end
end
