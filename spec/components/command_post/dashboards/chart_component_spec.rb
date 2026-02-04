require "rails_helper"
require_relative "../../../../app/components/command_post/dashboards/chart_component"

RSpec.describe CommandPost::Dashboards::ChartComponent, type: :component do
  describe "#initialize" do
    it "requires title" do
      component = described_class.new(title: "Revenue")
      expect(component.title).to eq("Revenue")
    end

    it "defaults type to line" do
      component = described_class.new(title: "Revenue")
      expect(component.type).to eq(:line)
    end

    it "defaults height to 300" do
      component = described_class.new(title: "Revenue")
      expect(component.height).to eq(300)
    end

    it "accepts data and labels" do
      component = described_class.new(
        title: "Revenue",
        data: [100, 200, 300],
        labels: %w[Jan Feb Mar]
      )
      expect(component.data).to eq([100, 200, 300])
      expect(component.labels).to eq(%w[Jan Feb Mar])
    end

    it "accepts custom type" do
      component = described_class.new(title: "Revenue", type: :bar)
      expect(component.type).to eq(:bar)
    end
  end

  describe "#chart_id" do
    it "returns unique id" do
      component = described_class.new(title: "Revenue")
      expect(component.chart_id).to start_with("chart-")
    end
  end

  describe "#chart_config" do
    it "returns valid JSON" do
      component = described_class.new(
        title: "Revenue",
        data: [100, 200],
        labels: %w[Jan Feb]
      )
      config = JSON.parse(component.chart_config)
      expect(config["type"]).to eq("line")
      expect(config["data"]["labels"]).to eq(%w[Jan Feb])
    end

    it "includes datasets" do
      component = described_class.new(
        title: "Revenue",
        data: [100, 200],
        labels: %w[Jan Feb]
      )
      config = JSON.parse(component.chart_config)
      expect(config["data"]["datasets"]).to be_present
      expect(config["data"]["datasets"].first["data"]).to eq([100, 200])
    end
  end

  describe "#chart_colors" do
    it "returns array of colors" do
      component = described_class.new(title: "Revenue")
      expect(component.chart_colors).to be_an(Array)
      expect(component.chart_colors.first).to include("rgba")
    end
  end
end
