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

  describe "field readonly enforcement" do
    let(:user) { double("User") }

    context "when field is readonly for user" do
      let(:field) { CommandPost::Field.new(:active, readonly: true) }

      it "renders disabled checkbox" do
        result = render_inline(described_class.new(name: :active, field: field, current_user: user))
        expect(result.css("input[type='checkbox'][disabled]")).to be_present
      end
    end

    context "when field uses proc for readonly" do
      let(:admin_user) { double("User", admin?: true) }
      let(:regular_user) { double("User", admin?: false) }
      let(:field) { CommandPost::Field.new(:active, readonly: ->(user) { !user.admin? }) }

      it "renders disabled checkbox for non-admin" do
        result = render_inline(described_class.new(name: :active, field: field, current_user: regular_user))
        expect(result.css("input[type='checkbox'][disabled]")).to be_present
      end

      it "renders enabled checkbox for admin" do
        result = render_inline(described_class.new(name: :active, field: field, current_user: admin_user))
        expect(result.css("input[type='checkbox'][disabled]")).not_to be_present
      end
    end

    context "when field is not readonly" do
      let(:field) { CommandPost::Field.new(:active, readonly: false) }

      it "renders enabled checkbox" do
        result = render_inline(described_class.new(name: :active, field: field, current_user: user))
        expect(result.css("input[type='checkbox'][disabled]")).not_to be_present
      end
    end

    context "when no field is provided" do
      it "uses disabled parameter only" do
        result = render_inline(described_class.new(name: :active, disabled: false))
        expect(result.css("input[type='checkbox'][disabled]")).not_to be_present
      end
    end
  end
end
