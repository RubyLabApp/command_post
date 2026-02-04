require "rails_helper"
require_relative "../../../../app/components/command_post/form/select_component"

RSpec.describe CommandPost::Form::SelectComponent, type: :component do
  let(:options) { [%w[Active active], %w[Inactive inactive]] }

  describe "#initialize" do
    it "requires name and options" do
      component = described_class.new(name: :status, options: options)
      expect(component.name).to eq(:status)
      expect(component.options).to eq(options)
    end

    it "defaults include_blank to nil" do
      component = described_class.new(name: :status, options: options)
      expect(component.include_blank).to be_nil
    end

    it "defaults disabled to false" do
      component = described_class.new(name: :status, options: options)
      expect(component.disabled).to be false
    end

    it "accepts selected value" do
      component = described_class.new(name: :status, options: options, selected: "active")
      expect(component.selected).to eq("active")
    end
  end

  describe "#select_classes" do
    it "includes appearance-none" do
      component = described_class.new(name: :status, options: options)
      expect(component.select_classes).to include("appearance-none")
    end

    it "includes error classes when has_error" do
      component = described_class.new(name: :status, options: options, has_error: true)
      expect(component.select_classes).to include("border-red-400")
    end
  end

  describe "#chevron_style" do
    it "returns background-image style for chevron" do
      component = described_class.new(name: :status, options: options)
      expect(component.chevron_style).to include("background-image")
      expect(component.chevron_style).to include("svg")
    end
  end
end
