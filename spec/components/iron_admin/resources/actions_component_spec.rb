require "rails_helper"
require_relative "../../../../app/components/iron_admin/resources/actions_component"

RSpec.describe IronAdmin::Resources::ActionsComponent, type: :component do
  before do
    IronAdmin::ResourceRegistry.register(IronAdmin::Resources::UserResource)
  end

  let(:user) { create(:user) }
  let(:actions) { [{ name: :archive, label: "Archive" }] }

  describe "#initialize" do
    it "stores actions" do
      component = described_class.new(actions: actions, record: user, resource_class: IronAdmin::Resources::UserResource)
      expect(component.actions).to eq(actions)
    end

    it "stores record" do
      component = described_class.new(actions: actions, record: user, resource_class: IronAdmin::Resources::UserResource)
      expect(component.record).to eq(user)
    end

    it "stores resource_class" do
      component = described_class.new(actions: actions, record: user, resource_class: IronAdmin::Resources::UserResource)
      expect(component.resource_class).to eq(IronAdmin::Resources::UserResource)
    end
  end

  describe "#render?" do
    it "returns true when actions exist" do
      component = described_class.new(actions: actions, record: user, resource_class: IronAdmin::Resources::UserResource)
      expect(component.render?).to be true
    end

    it "returns false when actions are empty" do
      component = described_class.new(actions: [], record: user, resource_class: IronAdmin::Resources::UserResource)
      expect(component.render?).to be false
    end
  end
end
