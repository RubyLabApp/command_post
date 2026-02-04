require "rails_helper"

RSpec.describe CommandPost do
  describe "VERSION" do
    it "is defined" do
      expect(CommandPost::VERSION).to be_present
    end

    it "follows semantic versioning format" do
      expect(CommandPost::VERSION).to match(/\A\d+\.\d+\.\d+\z/)
    end

    it "is frozen" do
      expect(CommandPost::VERSION).to be_frozen
    end
  end
end
