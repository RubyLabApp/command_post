require "rails_helper"
require_relative "../../../../app/components/command_post/ui/modal_component"

RSpec.describe CommandPost::UI::ModalComponent, type: :component do
  describe "#initialize" do
    it "defaults size to md" do
      component = described_class.new
      expect(component.size).to eq(:md)
    end

    it "defaults dismissible to true" do
      component = described_class.new
      expect(component.dismissible).to be true
    end

    it "accepts custom size" do
      component = described_class.new(size: :lg)
      expect(component.size).to eq(:lg)
    end

    it "accepts dismissible false" do
      component = described_class.new(dismissible: false)
      expect(component.dismissible).to be false
    end

    it "converts string size to symbol" do
      component = described_class.new(size: "xl")
      expect(component.size).to eq(:xl)
    end
  end

  describe "#size_classes" do
    it "returns max-w-md for sm size" do
      component = described_class.new(size: :sm)
      expect(component.size_classes).to eq("max-w-md")
    end

    it "returns max-w-lg for md size" do
      component = described_class.new(size: :md)
      expect(component.size_classes).to eq("max-w-lg")
    end

    it "returns max-w-2xl for lg size" do
      component = described_class.new(size: :lg)
      expect(component.size_classes).to eq("max-w-2xl")
    end

    it "returns max-w-4xl for xl size" do
      component = described_class.new(size: :xl)
      expect(component.size_classes).to eq("max-w-4xl")
    end

    it "returns full width for full size" do
      component = described_class.new(size: :full)
      expect(component.size_classes).to include("max-w-full")
    end

    it "falls back to md for unknown size" do
      component = described_class.new(size: :unknown)
      expect(component.size_classes).to eq("max-w-lg")
    end
  end

  describe "#modal_classes" do
    it "includes relative positioning" do
      component = described_class.new
      expect(component.modal_classes).to include("relative")
    end

    it "includes size class" do
      component = described_class.new(size: :lg)
      expect(component.modal_classes).to include("max-w-2xl")
    end

    it "includes full width" do
      component = described_class.new
      expect(component.modal_classes).to include("w-full")
    end
  end

  describe "slots" do
    it "has title slot" do
      expect(described_class.registered_slots).to have_key(:title)
    end

    it "has footer slot" do
      expect(described_class.registered_slots).to have_key(:footer)
    end
  end
end
