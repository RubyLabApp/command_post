require "rails_helper"
require_relative "../../../../app/components/command_post/form/text_input_component"

RSpec.describe CommandPost::Form::TextInputComponent, type: :component do
  describe "#initialize" do
    it "requires name" do
      component = described_class.new(name: :email)
      expect(component.name).to eq(:email)
    end

    it "defaults type to text" do
      component = described_class.new(name: :email)
      expect(component.type).to eq(:text)
    end

    it "defaults disabled to false" do
      component = described_class.new(name: :email)
      expect(component.disabled).to be false
    end

    it "defaults readonly to false" do
      component = described_class.new(name: :email)
      expect(component.readonly).to be false
    end

    it "defaults has_error to false" do
      component = described_class.new(name: :email)
      expect(component.has_error).to be false
    end

    it "generates placeholder from name" do
      component = described_class.new(name: :user_email)
      expect(component.placeholder).to eq("User email")
    end
  end

  describe "#input_classes" do
    it "includes border class" do
      component = described_class.new(name: :email)
      expect(component.input_classes).to include("border")
    end

    it "includes error classes when has_error" do
      component = described_class.new(name: :email, has_error: true)
      expect(component.input_classes).to include("border-red-400")
    end

    it "includes disabled classes when disabled" do
      component = described_class.new(name: :email, disabled: true)
      expect(component.input_classes).to include("cursor-not-allowed")
    end
  end

  describe "#call" do
    it "renders an input element" do
      result = render_inline(described_class.new(name: :email, value: "test@example.com"))
      expect(result.css("input[type='text']")).to be_present
      expect(result.css("input[value='test@example.com']")).to be_present
    end

    it "renders disabled input" do
      result = render_inline(described_class.new(name: :email, disabled: true))
      expect(result.css("input[disabled]")).to be_present
    end
  end
end
