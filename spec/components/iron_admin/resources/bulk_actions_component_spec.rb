require "rails_helper"
require_relative "../../../../app/components/iron_admin/resources/bulk_actions_component"

RSpec.describe IronAdmin::Resources::BulkActionsComponent, type: :component do
  before do
    IronAdmin::ResourceRegistry.register(IronAdmin::Resources::UserResource)
  end

  let(:actions) { [{ name: :archive, label: "Archive Selected" }] }

  describe "#initialize" do
    it "stores actions" do
      component = described_class.new(actions: actions, resource_class: IronAdmin::Resources::UserResource)
      expect(component.actions).to eq(actions)
    end

    it "stores resource_class" do
      component = described_class.new(actions: actions, resource_class: IronAdmin::Resources::UserResource)
      expect(component.resource_class).to eq(IronAdmin::Resources::UserResource)
    end
  end

  describe "#render?" do
    it "returns true when actions exist" do
      component = described_class.new(actions: actions, resource_class: IronAdmin::Resources::UserResource)
      expect(component.render?).to be true
    end

    it "returns false when actions are empty" do
      component = described_class.new(actions: [], resource_class: IronAdmin::Resources::UserResource)
      expect(component.render?).to be false
    end
  end
end
