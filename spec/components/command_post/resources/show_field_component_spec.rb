require "rails_helper"
require_relative "../../../../app/components/command_post/resources/show_field_component"

RSpec.describe CommandPost::Resources::ShowFieldComponent, type: :component do
  before do
    CommandPost::ResourceRegistry.register(UserResource)
  end

  let(:user) { create(:user, name: "John Doe") }
  let(:field) { UserResource.resolved_fields.find { |f| f.name == :name } }

  describe "#initialize" do
    it "stores field" do
      component = described_class.new(field: field, record: user)
      expect(component.field).to eq(field)
    end

    it "stores record" do
      component = described_class.new(field: field, record: user)
      expect(component.record).to eq(user)
    end
  end

  describe "#label" do
    it "humanizes field name" do
      component = described_class.new(field: field, record: user)
      expect(component.label).to eq("Name")
    end
  end
end
