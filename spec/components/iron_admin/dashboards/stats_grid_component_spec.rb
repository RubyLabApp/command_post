require "rails_helper"
require_relative "../../../../app/components/iron_admin/dashboards/stats_grid_component"

RSpec.describe IronAdmin::Dashboards::StatsGridComponent, type: :component do
  describe "#initialize" do
    it "defaults columns to 4" do
      component = described_class.new
      expect(component.columns).to eq(4)
    end

    it "accepts custom columns" do
      component = described_class.new(columns: 3)
      expect(component.columns).to eq(3)
    end
  end

  describe "#grid_classes" do
    it "returns 2-column classes" do
      component = described_class.new(columns: 2)
      expect(component.grid_classes).to include("sm:grid-cols-2")
    end

    it "returns 3-column classes" do
      component = described_class.new(columns: 3)
      expect(component.grid_classes).to include("lg:grid-cols-3")
    end

    it "returns 4-column classes" do
      component = described_class.new(columns: 4)
      expect(component.grid_classes).to include("lg:grid-cols-4")
    end
  end

  describe "slots" do
    it "has stats slot" do
      expect(described_class.registered_slots).to have_key(:stats)
    end
  end
end

RSpec.describe IronAdmin::Dashboards::StatsGridComponent::StatComponent, type: :component do
  describe "#initialize" do
    it "requires label and value" do
      component = described_class.new(label: "Users", value: 100)
      expect(component.label).to eq("Users")
      expect(component.value).to eq(100)
    end

    it "defaults change_type to neutral" do
      component = described_class.new(label: "Users", value: 100)
      expect(component.change_type).to eq(:neutral)
    end

    it "accepts change and change_type" do
      component = described_class.new(label: "Users", value: 100, change: "+10%", change_type: :positive)
      expect(component.change).to eq("+10%")
      expect(component.change_type).to eq(:positive)
    end
  end

  describe "#change_classes" do
    it "returns green for positive" do
      component = described_class.new(label: "Users", value: 100, change_type: :positive)
      expect(component.change_classes).to include("green")
    end

    it "returns red for negative" do
      component = described_class.new(label: "Users", value: 100, change_type: :negative)
      expect(component.change_classes).to include("red")
    end
  end

  describe "#change_icon" do
    it "returns trending up for positive" do
      component = described_class.new(label: "Users", value: 100, change_type: :positive)
      expect(component.change_icon).to eq("arrow-trending-up")
    end

    it "returns trending down for negative" do
      component = described_class.new(label: "Users", value: 100, change_type: :negative)
      expect(component.change_icon).to eq("arrow-trending-down")
    end

    it "returns nil for neutral" do
      component = described_class.new(label: "Users", value: 100, change_type: :neutral)
      expect(component.change_icon).to be_nil
    end
  end
end
