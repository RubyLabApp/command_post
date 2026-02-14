require "rails_helper"
require_relative "../../../../app/components/iron_admin/resources/related_list_component"

RSpec.describe IronAdmin::Resources::RelatedListComponent, type: :component do
  before do
    IronAdmin::ResourceRegistry.register(UserResource)
  end

  let(:association) do
    { name: :posts, resource: UserResource, display: :name }
  end

  describe "#initialize" do
    it "stores association" do
      records = User.none
      component = described_class.new(association: association, records: records)
      expect(component.association).to eq(association)
    end

    it "defaults limit to 20" do
      records = User.none
      component = described_class.new(association: association, records: records)
      expect(component.limit).to eq(20)
    end

    it "accepts custom limit" do
      records = User.none
      component = described_class.new(association: association, records: records, limit: 10)
      expect(component.limit).to eq(10)
    end
  end

  describe "#title" do
    it "humanizes association name" do
      records = User.none
      component = described_class.new(association: association, records: records)
      expect(component.title).to eq("Posts")
    end
  end

  describe "#resource_name" do
    it "returns association resource name" do
      records = User.none
      component = described_class.new(association: association, records: records)
      expect(component.resource_name).to eq(UserResource.resource_name)
    end
  end

  describe "#display_method" do
    it "returns association display method" do
      records = User.none
      component = described_class.new(association: association, records: records)
      expect(component.display_method).to eq(:name)
    end
  end

  describe "#render?" do
    it "returns false when records are empty" do
      records = User.none
      component = described_class.new(association: association, records: records)
      expect(component.render?).to be false
    end

    it "returns true when records exist" do
      create_list(:user, 2)
      records = User.all
      component = described_class.new(association: association, records: records)
      expect(component.render?).to be true
    end
  end
end
