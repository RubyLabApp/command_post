require "rails_helper"

RSpec.describe CommandPost::Dashboard::RecentTableComponent, type: :component do
  before do
    CommandPost::ResourceRegistry.register(UserResource)
  end

  describe "#initialize" do
    it "stores resource_name" do
      component = described_class.new(resource_name: :user, records: [])

      expect(component.instance_variable_get(:@resource_name)).to eq(:user)
    end

    it "stores records" do
      records = [double("Record")]
      component = described_class.new(resource_name: :user, records: records)

      expect(component.instance_variable_get(:@records)).to eq(records)
    end
  end

  describe "#label" do
    it "returns humanized pluralized resource name" do
      component = described_class.new(resource_name: :user, records: [])

      expect(component.label).to eq("Users")
    end

    it "handles underscored names" do
      component = described_class.new(resource_name: :license_type, records: [])

      expect(component.label).to eq("License types")
    end
  end

  describe "#fields" do
    context "when resource exists in registry" do
      it "returns first 4 fields" do
        component = described_class.new(resource_name: :user, records: [])

        fields = component.fields
        expect(fields.length).to be <= 4
      end

      it "returns Field objects" do
        component = described_class.new(resource_name: :user, records: [])

        fields = component.fields
        expect(fields).to all(be_a(CommandPost::Field))
      end
    end

    context "when resource does not exist in registry" do
      it "returns empty array" do
        component = described_class.new(resource_name: :nonexistent, records: [])

        expect(component.fields).to eq([])
      end
    end
  end

  describe "rendering" do
    before do
      vc_test_controller.view_context.class.define_method(:heroicon) do |name, **_opts|
        "<svg class=\"heroicon-#{name}\"></svg>".html_safe
      end
    end

    it "renders with empty records" do
      result = render_inline(described_class.new(resource_name: :user, records: []))

      expect(result.to_html).to include("Users")
    end

    it "renders with records" do
      users = create_list(:user, 2)
      result = render_inline(described_class.new(resource_name: :user, records: users))

      expect(result.to_html).to include("Users")
    end
  end
end
