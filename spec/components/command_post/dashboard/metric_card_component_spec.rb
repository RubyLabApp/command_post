require "rails_helper"

RSpec.describe CommandPost::Dashboard::MetricCardComponent, type: :component do
  include ViewComponent::TestHelpers

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
