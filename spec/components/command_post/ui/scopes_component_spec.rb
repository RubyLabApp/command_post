require "rails_helper"
require_relative "../../../../app/components/command_post/ui/scopes_component"

RSpec.describe CommandPost::Ui::ScopesComponent, type: :component do
  let(:scopes) do
    [
      { name: :all, label: "All" },
      { name: :active, label: "Active" },
      { name: :inactive, label: "Inactive" },
    ]
  end

  describe "#initialize" do
    it "stores scopes" do
      component = described_class.new(scopes: scopes, current_scope: "all", base_path: "/admin/users")
      expect(component.scopes).to eq(scopes)
    end

    it "stores current_scope" do
      component = described_class.new(scopes: scopes, current_scope: "active", base_path: "/admin/users")
      expect(component.current_scope).to eq("active")
    end

    it "stores base_path" do
      component = described_class.new(scopes: scopes, current_scope: "all", base_path: "/admin/users")
      expect(component.base_path).to eq("/admin/users")
    end

    it "defaults params to empty hash" do
      component = described_class.new(scopes: scopes, current_scope: "all", base_path: "/admin/users")
      expect(component.params).to eq({})
    end

    it "accepts custom params" do
      component = described_class.new(scopes: scopes, current_scope: "all", base_path: "/admin/users", params: { q: "test" })
      expect(component.params).to eq({ q: "test" })
    end
  end

  describe "#scope_url" do
    it "generates URL with scope param" do
      component = described_class.new(scopes: scopes, current_scope: "all", base_path: "/admin/users")
      expect(component.scope_url(:active)).to include("scope=active")
    end

    it "preserves existing params" do
      component = described_class.new(scopes: scopes, current_scope: "all", base_path: "/admin/users", params: { q: "test" })
      url = component.scope_url(:active)
      expect(url).to include("q=test")
      expect(url).to include("scope=active")
    end
  end

  describe "#active?" do
    it "returns true when scope matches current_scope" do
      component = described_class.new(scopes: scopes, current_scope: "active", base_path: "/admin/users")
      expect(component.active?({ name: :active })).to be true
    end

    it "returns false when scope does not match" do
      component = described_class.new(scopes: scopes, current_scope: "active", base_path: "/admin/users")
      expect(component.active?({ name: :inactive })).to be false
    end
  end

  describe "#scope_classes" do
    it "includes active classes for active scope" do
      component = described_class.new(scopes: scopes, current_scope: "active", base_path: "/admin/users")
      classes = component.scope_classes({ name: :active })
      expect(classes).to include("border-b-2")
    end

    it "includes base classes" do
      component = described_class.new(scopes: scopes, current_scope: "all", base_path: "/admin/users")
      classes = component.scope_classes({ name: :all })
      expect(classes).to include("px-4")
      expect(classes).to include("py-2")
      expect(classes).to include("text-sm")
    end
  end

  describe "#render?" do
    it "returns true when scopes exist" do
      component = described_class.new(scopes: scopes, current_scope: "all", base_path: "/admin/users")
      expect(component.render?).to be true
    end

    it "returns false when scopes are empty" do
      component = described_class.new(scopes: [], current_scope: "all", base_path: "/admin/users")
      expect(component.render?).to be false
    end
  end
end
