require "rails_helper"
require_relative "../../../../app/components/command_post/form/checkbox_component"

RSpec.describe CommandPost::Form::CheckboxComponent, type: :component do
  describe "#initialize" do
    it "requires name" do
      component = described_class.new(name: :active)
      expect(component.name).to eq(:active)
    end

    it "defaults checked to false" do
      component = described_class.new(name: :active)
      expect(component.checked).to be false
    end

    it "defaults disabled to false" do
      component = described_class.new(name: :active)
      expect(component.disabled).to be false
    end

    it "accepts label" do
      component = described_class.new(name: :active, label: "Is active")
      expect(component.label).to eq("Is active")
    end
  end

  describe "#checkbox_classes" do
    it "includes h-4 w-4" do
      component = described_class.new(name: :active)
      expect(component.checkbox_classes).to include("h-4")
      expect(component.checkbox_classes).to include("w-4")
    end

    it "includes rounded" do
      component = described_class.new(name: :active)
      expect(component.checkbox_classes).to include("rounded")
    end
  end
end
