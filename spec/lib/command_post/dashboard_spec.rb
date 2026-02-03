require "rails_helper"

class TestDashboard < CommandPost::Dashboard
  metric :total_users do
    42
  end

  metric :revenue, format: :currency do
    1500.50
  end

  chart :users_over_time, type: :line do
    { "Jan" => 10, "Feb" => 20 }
  end

  recent :users, limit: 5, scope: -> { order(created_at: :desc) }
end

RSpec.describe CommandPost::Dashboard do
  describe "metrics" do
    it "stores metric definitions" do
      expect(TestDashboard.defined_metrics.length).to eq(2)
    end

    it "evaluates metric value" do
      metric = TestDashboard.defined_metrics.first
      expect(metric[:block].call).to eq(42)
    end

    it "stores format option" do
      metric = TestDashboard.defined_metrics.last
      expect(metric[:format]).to eq(:currency)
    end
  end

  describe "charts" do
    it "stores chart definitions" do
      expect(TestDashboard.defined_charts.length).to eq(1)
      expect(TestDashboard.defined_charts.first[:type]).to eq(:line)
    end
  end

  describe "recents" do
    it "stores recent definitions" do
      expect(TestDashboard.defined_recents.length).to eq(1)
      expect(TestDashboard.defined_recents.first[:limit]).to eq(5)
    end
  end
end
