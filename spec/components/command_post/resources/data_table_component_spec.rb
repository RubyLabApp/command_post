require "rails_helper"
require_relative "../../../../app/components/command_post/resources/data_table_component"

RSpec.describe CommandPost::Resources::DataTableComponent, type: :component do
  before do
    CommandPost::ResourceRegistry.register(UserResource)
  end

  let(:users) { create_list(:user, 3) }
  let(:fields) { UserResource.resolved_fields.first(3) }

  describe "#initialize" do
    it "stores records" do
      component = described_class.new(
        records: users,
        fields: fields,
        resource_class: UserResource,
        base_url: "/admin/users?"
      )
      expect(component.records).to eq(users)
    end

    it "stores fields" do
      component = described_class.new(
        records: users,
        fields: fields,
        resource_class: UserResource,
        base_url: "/admin/users?"
      )
      expect(component.fields).to eq(fields)
    end

    it "stores resource_class" do
      component = described_class.new(
        records: users,
        fields: fields,
        resource_class: UserResource,
        base_url: "/admin/users?"
      )
      expect(component.resource_class).to eq(UserResource)
    end
  end

  describe "#empty?" do
    it "returns true when records are empty" do
      component = described_class.new(
        records: [],
        fields: fields,
        resource_class: UserResource,
        base_url: "/admin/users?"
      )
      expect(component.empty?).to be true
    end

    it "returns false when records exist" do
      component = described_class.new(
        records: users,
        fields: fields,
        resource_class: UserResource,
        base_url: "/admin/users?"
      )
      expect(component.empty?).to be false
    end
  end

  describe "#sort_url" do
    it "returns URL with sort params" do
      component = described_class.new(
        records: users,
        fields: fields,
        resource_class: UserResource,
        base_url: "/admin/users?"
      )
      expect(component.sort_url(:name)).to include("sort=name")
      expect(component.sort_url(:name)).to include("direction=asc")
    end

    it "toggles direction when already sorted asc" do
      component = described_class.new(
        records: users,
        fields: fields,
        resource_class: UserResource,
        current_sort: "name",
        current_direction: "asc",
        base_url: "/admin/users?"
      )
      expect(component.sort_url(:name)).to include("direction=desc")
    end
  end

  describe "#sorted?" do
    it "returns true when field matches current_sort" do
      component = described_class.new(
        records: users,
        fields: fields,
        resource_class: UserResource,
        current_sort: "name",
        base_url: "/admin/users?"
      )
      expect(component.sorted?(:name)).to be true
    end

    it "returns false when field does not match" do
      component = described_class.new(
        records: users,
        fields: fields,
        resource_class: UserResource,
        current_sort: "email",
        base_url: "/admin/users?"
      )
      expect(component.sorted?(:name)).to be false
    end
  end
end
