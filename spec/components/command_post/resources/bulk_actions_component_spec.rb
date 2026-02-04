require "rails_helper"
require_relative "../../../../app/components/command_post/resources/bulk_actions_component"

RSpec.describe CommandPost::Resources::BulkActionsComponent, type: :component do
  before do
    CommandPost::ResourceRegistry.register(UserResource)
  end

  let(:actions) { [{ name: :archive, label: "Archive Selected" }] }

  describe "#initialize" do
    it "stores actions" do
      component = described_class.new(actions: actions, resource_class: UserResource)
      expect(component.actions).to eq(actions)
    end

    it "stores resource_class" do
      component = described_class.new(actions: actions, resource_class: UserResource)
      expect(component.resource_class).to eq(UserResource)
    end
  end

  describe "#render?" do
    it "returns true when actions exist" do
      component = described_class.new(actions: actions, resource_class: UserResource)
      expect(component.render?).to be true
    end

    it "returns false when actions are empty" do
      component = described_class.new(actions: [], resource_class: UserResource)
      expect(component.render?).to be false
    end
  end
end
