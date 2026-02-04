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

  describe "field readonly enforcement" do
    let(:user) { double("User") }

    context "when field is readonly for user" do
      let(:field) { CommandPost::Field.new(:email, readonly: true) }

      it "renders disabled input" do
        result = render_inline(described_class.new(name: :email, field: field, current_user: user))
        expect(result.css("input[disabled]")).to be_present
      end

      it "includes disabled classes" do
        component = described_class.new(name: :email, field: field, current_user: user)
        expect(component.input_classes).to include("cursor-not-allowed")
      end
    end

    context "when field uses proc for readonly" do
      let(:admin_user) { double("User", admin?: true) }
      let(:regular_user) { double("User", admin?: false) }
      let(:field) { CommandPost::Field.new(:email, readonly: ->(user) { !user.admin? }) }

      it "renders disabled input for non-admin" do
        result = render_inline(described_class.new(name: :email, field: field, current_user: regular_user))
        expect(result.css("input[disabled]")).to be_present
      end

      it "renders enabled input for admin" do
        result = render_inline(described_class.new(name: :email, field: field, current_user: admin_user))
        expect(result.css("input[disabled]")).not_to be_present
      end
    end

    context "when field is not readonly" do
      let(:field) { CommandPost::Field.new(:email, readonly: false) }

      it "renders enabled input" do
        result = render_inline(described_class.new(name: :email, field: field, current_user: user))
        expect(result.css("input[disabled]")).not_to be_present
      end
    end

    context "when no field is provided" do
      it "uses disabled parameter only" do
        result = render_inline(described_class.new(name: :email, disabled: false))
        expect(result.css("input[disabled]")).not_to be_present
      end
    end
  end
end
