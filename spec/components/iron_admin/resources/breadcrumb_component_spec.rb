require "rails_helper"
require_relative "../../../../app/components/iron_admin/resources/breadcrumb_component"

RSpec.describe IronAdmin::Resources::BreadcrumbComponent, type: :component do
  describe "slots" do
    it "has items slot" do
      expect(described_class.registered_slots).to have_key(:items)
    end
  end
end

RSpec.describe IronAdmin::Resources::BreadcrumbComponent::ItemComponent, type: :component do
  describe "#initialize" do
    it "stores label" do
      component = described_class.new(label: "Users")
      expect(component.label).to eq("Users")
    end

    it "defaults href to nil" do
      component = described_class.new(label: "Users")
      expect(component.href).to be_nil
    end

    it "defaults current to false" do
      component = described_class.new(label: "Users")
      expect(component.current).to be false
    end

    it "accepts all options" do
      component = described_class.new(label: "Users", href: "/admin/users", current: true)
      expect(component.href).to eq("/admin/users")
      expect(component.current).to be true
    end
  end

  describe "#item_classes" do
    it "includes text-sm" do
      component = described_class.new(label: "Users")
      expect(component.item_classes).to include("text-sm")
    end

    it "includes font-medium when current" do
      component = described_class.new(label: "Users", current: true)
      expect(component.item_classes).to include("font-medium")
    end
  end

  describe "#call" do
    it "renders a link when href is present and not current" do
      result = render_inline(described_class.new(label: "Users", href: "/admin/users"))
      expect(result.css("a[href='/admin/users']")).to be_present
      expect(result.css("a").text).to eq("Users")
    end

    it "renders a span when current" do
      result = render_inline(described_class.new(label: "Edit", current: true))
      expect(result.css("span")).to be_present
      expect(result.css("span[aria-current='page']")).to be_present
    end

    it "renders a span when no href" do
      result = render_inline(described_class.new(label: "Details"))
      expect(result.css("span")).to be_present
    end
  end
end
