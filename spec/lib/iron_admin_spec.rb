require "rails_helper"

RSpec.describe IronAdmin do
  describe "VERSION" do
    it "is defined" do
      expect(IronAdmin::VERSION).to be_present
    end

    it "follows semantic versioning format" do
      expect(IronAdmin::VERSION).to match(/\A\d+\.\d+\.\d+\z/)
    end

    it "is frozen" do
      expect(IronAdmin::VERSION).to be_frozen
    end
  end
end
