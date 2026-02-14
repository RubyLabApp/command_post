require "rails_helper"
require_relative "../../../../app/components/iron_admin/ui/alert_component"

RSpec.describe IronAdmin::Ui::AlertComponent, type: :component do
  describe "#initialize" do
    it "stores message" do
      component = described_class.new(message: "Test message")
      expect(component.message).to eq("Test message")
    end

    it "defaults type to info" do
      component = described_class.new(message: "Test")
      expect(component.type).to eq(:info)
    end

    it "defaults dismissible to true" do
      component = described_class.new(message: "Test")
      expect(component.dismissible).to be true
    end

    it "accepts custom type" do
      component = described_class.new(message: "Test", type: :error)
      expect(component.type).to eq(:error)
    end
  end

  describe "#type_config" do
    it "returns success config" do
      component = described_class.new(message: "Test", type: :success)
      config = component.type_config
      expect(config[:bg]).to include("green")
      expect(config[:icon]).to eq("check-circle")
    end

    it "returns error config" do
      component = described_class.new(message: "Test", type: :error)
      config = component.type_config
      expect(config[:bg]).to include("red")
      expect(config[:icon]).to eq("x-circle")
    end

    it "returns warning config" do
      component = described_class.new(message: "Test", type: :warning)
      config = component.type_config
      expect(config[:bg]).to include("yellow")
    end

    it "returns info config" do
      component = described_class.new(message: "Test", type: :info)
      config = component.type_config
      expect(config[:bg]).to include("blue")
    end
  end

  describe "#render?" do
    it "returns true when message is present" do
      component = described_class.new(message: "Test")
      expect(component.render?).to be true
    end

    it "returns false when message is blank" do
      component = described_class.new(message: "")
      expect(component.render?).to be false
    end
  end
end
