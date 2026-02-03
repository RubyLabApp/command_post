require "rails_helper"
require_relative "../../../support/test_resources"

RSpec.describe CommandPost::Layout::SidebarComponent, type: :component do
  include ViewComponent::TestHelpers

  before do
    CommandPost::ResourceRegistry.reset!
    CommandPost::ResourceRegistry.register(TestUserResource)
    CommandPost::ResourceRegistry.register(TestLicenseResource)

    vc_test_controller.view_context.class.define_method(:heroicon) do |name, **_opts|
      "<svg class=\"heroicon-#{name}\"></svg>".html_safe
    end
  end

  it "renders resource links" do
    result = render_inline(described_class.new)
    link_texts = result.css("a").map { |a| a.text.strip }

    expect(link_texts).to include("Users")
    expect(link_texts).to include("Licenses")
  end

  it "renders dashboard link" do
    result = render_inline(described_class.new)
    link_texts = result.css("a").map { |a| a.text.strip }

    expect(link_texts).to include("Dashboard")
  end

  it "groups resources by menu group" do
    result = render_inline(described_class.new)

    expect(result.text).to include("Licensing")
  end
end
