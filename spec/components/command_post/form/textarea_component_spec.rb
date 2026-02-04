require "rails_helper"
require_relative "../../../../app/components/command_post/form/textarea_component"

RSpec.describe CommandPost::Form::TextareaComponent, type: :component do
  describe "#initialize" do
    it "stores name" do
      component = described_class.new(name: :description)
      expect(component.name).to eq(:description)
    end

    it "defaults value to nil" do
      component = described_class.new(name: :description)
      expect(component.value).to be_nil
    end

    it "defaults rows to 4" do
      component = described_class.new(name: :description)
      expect(component.rows).to eq(4)
    end

    it "generates placeholder from name" do
      component = described_class.new(name: :user_bio)
      expect(component.placeholder).to eq("User bio")
    end

    it "accepts custom placeholder" do
      component = described_class.new(name: :description, placeholder: "Enter description...")
      expect(component.placeholder).to eq("Enter description...")
    end

    it "defaults disabled to false" do
      component = described_class.new(name: :description)
      expect(component.disabled).to be false
    end

    it "defaults readonly to false" do
      component = described_class.new(name: :description)
      expect(component.readonly).to be false
    end

    it "defaults has_error to false" do
      component = described_class.new(name: :description)
      expect(component.has_error).to be false
    end
  end

  describe "#textarea_classes" do
    it "includes w-full" do
      component = described_class.new(name: :description)
      expect(component.textarea_classes).to include("w-full")
    end

    it "includes border" do
      component = described_class.new(name: :description)
      expect(component.textarea_classes).to include("border")
    end

    it "includes resize-y" do
      component = described_class.new(name: :description)
      expect(component.textarea_classes).to include("resize-y")
    end

    it "includes error classes when has_error" do
      component = described_class.new(name: :description, has_error: true)
      expect(component.textarea_classes).to include("border-red-400")
    end

    it "includes disabled classes when disabled" do
      component = described_class.new(name: :description, disabled: true)
      expect(component.textarea_classes).to include("cursor-not-allowed")
    end

    it "includes disabled classes when readonly" do
      component = described_class.new(name: :description, readonly: true)
      expect(component.textarea_classes).to include("cursor-not-allowed")
    end
  end

  describe "#call" do
    it "renders a textarea element" do
      result = render_inline(described_class.new(name: :description))
      expect(result.css("textarea")).to be_present
    end

    it "renders with value" do
      result = render_inline(described_class.new(name: :description, value: "Test content"))
      expect(result.css("textarea").text).to eq("Test content")
    end

    it "renders with rows attribute" do
      result = render_inline(described_class.new(name: :description, rows: 6))
      expect(result.css("textarea[rows='6']")).to be_present
    end

    it "renders disabled textarea" do
      result = render_inline(described_class.new(name: :description, disabled: true))
      expect(result.css("textarea[disabled]")).to be_present
    end

    it "renders readonly textarea" do
      result = render_inline(described_class.new(name: :description, readonly: true))
      expect(result.css("textarea[readonly]")).to be_present
    end
  end
end
