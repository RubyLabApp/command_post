require "rails_helper"

RSpec.describe IronAdmin::Layout::NavbarComponent, type: :component do
  describe "#initialize" do
    it "accepts current_user parameter" do
      user = instance_double(User, name: "Test User")
      component = described_class.new(current_user: user)

      expect(component.instance_variable_get(:@current_user)).to eq(user)
    end

    it "defaults current_user to nil" do
      component = described_class.new

      expect(component.instance_variable_get(:@current_user)).to be_nil
    end
  end

  describe "component class" do
    it "inherits from ViewComponent::Base" do
      expect(described_class.superclass).to eq(ViewComponent::Base)
    end
  end
end
