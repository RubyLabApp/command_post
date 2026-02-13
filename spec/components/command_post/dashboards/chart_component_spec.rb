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
    it "returns theme colors by default" do
      component = described_class.new(title: "Revenue")
      expect(component.chart_colors).to eq(CommandPost.configuration.theme.chart_colors)
    end

    context "with per-chart colors" do
      it "returns per-chart colors over theme" do
        custom = ["#ff0000", "#00ff00"]
        component = described_class.new(title: "Revenue", colors: custom)
        expect(component.chart_colors).to eq(custom)
      end
    end

    context "with custom theme colors" do
      before do
        CommandPost.configuration.theme.chart_colors = ["#aaa", "#bbb"]
      end

      it "uses theme colors when no per-chart colors" do
        component = described_class.new(title: "Revenue")
        expect(component.chart_colors).to eq(["#aaa", "#bbb"])
      end

      it "prefers per-chart colors over theme" do
        custom = ["#111", "#222"]
        component = described_class.new(title: "Revenue", colors: custom)
        expect(component.chart_colors).to eq(custom)
      end
    end
  end

  describe "#chart_config" do
    context "with per-chart colors on bar chart" do
      it "uses per-chart colors as backgroundColor" do
        custom = ["#10b981", "#3b82f6"]
        component = described_class.new(title: "Status", type: :bar, data: [5, 10], labels: %w[A B], colors: custom)
        config = JSON.parse(component.chart_config)
        expect(config["data"]["datasets"].first["backgroundColor"]).to eq(custom)
        expect(config["data"]["datasets"].first["borderColor"]).to eq("#10b981")
      end
    end

    context "with per-chart colors on line chart" do
      it "uses first color as borderColor and transparent fill" do
        custom = ["#10b981", "#3b82f6"]
        component = described_class.new(title: "Trend", type: :line, data: [5, 10], labels: %w[A B], colors: custom)
        config = JSON.parse(component.chart_config)
        expect(config["data"]["datasets"].first["borderColor"]).to eq("#10b981")
        expect(config["data"]["datasets"].first["backgroundColor"]).to eq("#10b9811A")
      end
    end

    context "with theme border color" do
      before do
        CommandPost.configuration.theme.chart_border_color = "rgb(34, 197, 94)"
      end

      it "uses theme border color for line chart" do
        component = described_class.new(title: "Trend", type: :line, data: [5], labels: ["A"])
        config = JSON.parse(component.chart_config)
        expect(config["data"]["datasets"].first["borderColor"]).to eq("rgb(34, 197, 94)")
        expect(config["data"]["datasets"].first["backgroundColor"]).to eq("rgba(34, 197, 94, 0.1)")
      end
    end
  end
end
