require "rails_helper"
require_relative "../../support/test_resources"

RSpec.describe CommandPost::ResourceRegistry do
  before { described_class.reset! }

  describe ".register" do
    it "registers a resource class" do
      described_class.register(TestUserResource)
      expect(described_class.all).to include(TestUserResource)
    end
  end

  describe ".find" do
    it "finds resource by model name" do
      described_class.register(TestUserResource)
      expect(described_class.find("users")).to eq(TestUserResource)
    end
  end

  describe ".grouped" do
    it "groups resources by menu group" do
      described_class.register(TestUserResource)
      described_class.register(TestLicenseResource)

      groups = described_class.grouped
      expect(groups["Licensing"]).to include(TestLicenseResource)
    end
  end

  describe ".sorted" do
    it "sorts by menu priority" do
      described_class.register(TestUserResource)
      described_class.register(TestLicenseResource)

      sorted = described_class.sorted
      # UserResource has priority 0, LicenseResource has priority 1
      # Lower priority should come first
      expect(sorted.first).to eq(TestUserResource)
    end
  end
end
