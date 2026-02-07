require "rails_helper"
require_relative "../../../../app/components/command_post/ui/dropdown_component"

RSpec.describe CommandPost::Ui::DropdownComponent, type: :component do
  describe "#initialize" do
    it "defaults align to right" do
      component = described_class.new
      expect(component.align).to eq(:right)
    end

    it "defaults width to 48" do
      component = described_class.new
      expect(component.width).to eq(48)
    end

    it "accepts custom align" do
      component = described_class.new(align: :left)
      expect(component.align).to eq(:left)
    end

    it "accepts custom width" do
      component = described_class.new(width: 56)
      expect(component.width).to eq(56)
    end
  end

  describe "#dropdown_classes" do
    it "includes right-0 for right align" do
      component = described_class.new(align: :right)
      expect(component.dropdown_classes).to include("right-0")
    end

    it "includes left-0 for left align" do
      component = described_class.new(align: :left)
      expect(component.dropdown_classes).to include("left-0")
    end

    it "includes width class" do
      component = described_class.new(width: 48)
      expect(component.dropdown_classes).to include("w-48")
    end

    it "includes z-50 for stacking" do
      component = described_class.new
      expect(component.dropdown_classes).to include("z-50")
    end
  end

  describe "slots" do
    it "has trigger slot" do
      expect(described_class.registered_slots).to have_key(:trigger)
    end

    it "has items slot" do
      expect(described_class.registered_slots).to have_key(:items)
    end
  end
end

RSpec.describe CommandPost::Ui::DropdownComponent::ItemComponent, type: :component do
  describe "#initialize" do
    it "defaults href to nil" do
      component = described_class.new
      expect(component.href).to be_nil
    end

    it "defaults destructive to false" do
      component = described_class.new
      expect(component.destructive).to be false
    end

    it "accepts all options" do
      component = described_class.new(
        href: "/delete",
        method: :delete,
        icon: "trash",
        destructive: true
      )
      expect(component.href).to eq("/delete")
      expect(component.method).to eq(:delete)
      expect(component.icon).to eq("trash")
      expect(component.destructive).to be true
    end
  end

  describe "#item_classes" do
    it "includes destructive styles when destructive" do
      component = described_class.new(destructive: true)
      expect(component.item_classes).to include("text-red-600")
      expect(component.item_classes).to include("hover:bg-red-50")
    end

    it "includes normal styles when not destructive" do
      component = described_class.new(destructive: false)
      expect(component.item_classes).to include("text-gray-700")
      expect(component.item_classes).to include("hover:bg-gray-50")
    end

    it "includes flex layout" do
      component = described_class.new
      expect(component.item_classes).to include("flex")
    end
  end

  describe "#call" do
    before do
      vc_test_controller.view_context.class.define_method(:heroicon) do |name, **_opts|
        "<svg class=\"heroicon-#{name}\"></svg>".html_safe
      end
    end

    it "renders a link when href is present" do
      result = render_inline(described_class.new(href: "/users")) { "Edit" }
      expect(result.css("a[href='/users']")).to be_present
    end

    it "renders with turbo_method when method is set" do
      result = render_inline(described_class.new(href: "/delete", method: :delete)) { "Delete" }
      expect(result.css("a[data-turbo-method='delete']")).to be_present
    end

    it "renders a button when no href" do
      result = render_inline(described_class.new) { "Click" }
      expect(result.css("button[type='button']")).to be_present
    end

    it "renders icon when provided" do
      result = render_inline(described_class.new(icon: "trash")) { "Delete" }
      expect(result.css("svg.heroicon-trash")).to be_present
    end

    it "renders content" do
      result = render_inline(described_class.new) { "Menu Item" }
      expect(result.text).to include("Menu Item")
    end
  end
end
