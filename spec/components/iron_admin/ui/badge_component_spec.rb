require "rails_helper"
require_relative "../../../../app/components/iron_admin/ui/badge_component"

RSpec.describe IronAdmin::Ui::BadgeComponent, type: :component do
  describe "#initialize" do
    it "stores text" do
      component = described_class.new(text: "Active")
      expect(component.text).to eq("Active")
    end

    it "defaults color to gray" do
      component = described_class.new(text: "Test")
      expect(component.color).to eq(:gray)
    end

    it "defaults size to md" do
      component = described_class.new(text: "Test")
      expect(component.size).to eq(:md)
    end

    it "accepts custom color" do
      component = described_class.new(text: "Test", color: :green)
      expect(component.color).to eq(:green)
    end

    it "accepts custom size" do
      component = described_class.new(text: "Test", size: :lg)
      expect(component.size).to eq(:lg)
    end
  end

  describe "#color_classes" do
    it "returns classes for known colors" do
      component = described_class.new(text: "Test", color: :green)
      expect(component.color_classes).to include("bg-green-100")
    end

    it "falls back to gray for unknown colors" do
      component = described_class.new(text: "Test", color: :unknown)
      expect(component.color_classes).to include("bg-gray-100")
    end
  end

  describe "#size_classes" do
    it "returns sm classes" do
      component = described_class.new(text: "Test", size: :sm)
      expect(component.size_classes).to include("text-xs")
    end

    it "returns md classes" do
      component = described_class.new(text: "Test", size: :md)
      expect(component.size_classes).to include("text-sm")
    end

    it "returns lg classes" do
      component = described_class.new(text: "Test", size: :lg)
      expect(component.size_classes).to include("py-1")
    end
  end

  describe "#call" do
    it "renders a span with badge text" do
      result = render_inline(described_class.new(text: "Active"))
      expect(result.css("span").text).to eq("Active")
    end

    it "includes rounded-full class" do
      result = render_inline(described_class.new(text: "Test"))
      expect(result.css("span.rounded-full")).to be_present
    end
  end
end
