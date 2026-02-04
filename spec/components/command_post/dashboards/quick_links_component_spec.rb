require "rails_helper"
require_relative "../../../../app/components/command_post/dashboards/quick_links_component"

RSpec.describe CommandPost::Dashboards::QuickLinksComponent, type: :component do
  describe "#initialize" do
    it "defaults title to 'Quick Links'" do
      component = described_class.new
      expect(component.title).to eq("Quick Links")
    end

    it "accepts custom title" do
      component = described_class.new(title: "Shortcuts")
      expect(component.title).to eq("Shortcuts")
    end
  end

  describe "#render?" do
    it "returns true when links exist" do
      component = described_class.new
      allow(component).to receive(:links).and_return([double])
      expect(component.render?).to be true
    end

    it "returns false when links are empty" do
      component = described_class.new
      allow(component).to receive(:links).and_return([])
      expect(component.render?).to be false
    end
  end

  describe "slots" do
    it "has links slot" do
      expect(described_class.registered_slots).to have_key(:links)
    end
  end
end

RSpec.describe CommandPost::Dashboards::QuickLinksComponent::LinkComponent, type: :component do
  describe "#initialize" do
    it "stores label" do
      component = described_class.new(label: "Dashboard", href: "/dashboard")
      expect(component.label).to eq("Dashboard")
    end

    it "stores href" do
      component = described_class.new(label: "Dashboard", href: "/dashboard")
      expect(component.href).to eq("/dashboard")
    end

    it "defaults icon to nil" do
      component = described_class.new(label: "Dashboard", href: "/dashboard")
      expect(component.icon).to be_nil
    end

    it "defaults description to nil" do
      component = described_class.new(label: "Dashboard", href: "/dashboard")
      expect(component.description).to be_nil
    end

    it "accepts all options" do
      component = described_class.new(
        label: "Users",
        href: "/admin/users",
        icon: "users",
        description: "Manage user accounts"
      )
      expect(component.label).to eq("Users")
      expect(component.href).to eq("/admin/users")
      expect(component.icon).to eq("users")
      expect(component.description).to eq("Manage user accounts")
    end
  end
end
