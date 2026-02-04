require "rails_helper"
require_relative "../../../../app/components/command_post/dashboards/metric_card_component"

RSpec.describe CommandPost::Dashboards::MetricCardComponent, type: :component do
  it "renders metric name and value" do
    result = render_inline(described_class.new(name: :total_users, value: 42, format: :number))

    expect(result.text).to include("Total users")
    expect(result.text).to include("42")
  end

  it "formats currency" do
    result = render_inline(described_class.new(name: :revenue, value: 1500.50, format: :currency))

    expect(result.text).to include("$1,500.50")
  end
end
