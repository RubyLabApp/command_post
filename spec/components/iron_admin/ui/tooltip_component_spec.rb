require "rails_helper"
require_relative "../../../../app/components/iron_admin/ui/tooltip_component"

RSpec.describe IronAdmin::Ui::TooltipComponent, type: :component do
  describe "#initialize" do
    it "stores text" do
      component = described_class.new(text: "Helpful info")
      expect(component.text).to eq("Helpful info")
    end

    it "defaults position to top" do
      component = described_class.new(text: "Info")
      expect(component.position).to eq(:top)
    end

    it "accepts custom position" do
      component = described_class.new(text: "Info", position: :bottom)
      expect(component.position).to eq(:bottom)
    end

    it "converts string position to symbol" do
      component = described_class.new(text: "Info", position: "left")
      expect(component.position).to eq(:left)
    end
  end

  describe "#position_classes" do
    it "returns top position classes" do
      component = described_class.new(text: "Info", position: :top)
      expect(component.position_classes).to include("bottom-full")
      expect(component.position_classes).to include("mb-2")
    end

    it "returns bottom position classes" do
      component = described_class.new(text: "Info", position: :bottom)
      expect(component.position_classes).to include("top-full")
      expect(component.position_classes).to include("mt-2")
    end

    it "returns left position classes" do
      component = described_class.new(text: "Info", position: :left)
      expect(component.position_classes).to include("right-full")
      expect(component.position_classes).to include("mr-2")
    end

    it "returns right position classes" do
      component = described_class.new(text: "Info", position: :right)
      expect(component.position_classes).to include("left-full")
      expect(component.position_classes).to include("ml-2")
    end

    it "falls back to top for unknown position" do
      component = described_class.new(text: "Info", position: :unknown)
      expect(component.position_classes).to include("bottom-full")
    end
  end

  describe "#tooltip_classes" do
    it "includes absolute positioning" do
      component = described_class.new(text: "Info")
      expect(component.tooltip_classes).to include("absolute")
    end

    it "includes position classes" do
      component = described_class.new(text: "Info", position: :bottom)
      expect(component.tooltip_classes).to include("top-full")
    end

    it "includes base styling" do
      component = described_class.new(text: "Info")
      expect(component.tooltip_classes).to include("text-xs")
      expect(component.tooltip_classes).to include("bg-gray-900")
      expect(component.tooltip_classes).to include("text-white")
      expect(component.tooltip_classes).to include("rounded")
    end

    it "includes visibility classes" do
      component = described_class.new(text: "Info")
      expect(component.tooltip_classes).to include("opacity-0")
      expect(component.tooltip_classes).to include("group-hover:opacity-100")
    end

    it "includes z-index" do
      component = described_class.new(text: "Info")
      expect(component.tooltip_classes).to include("z-50")
    end
  end
end
