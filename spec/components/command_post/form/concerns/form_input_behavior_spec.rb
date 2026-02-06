require "rails_helper"
require_relative "../../../../../app/components/command_post/form/concerns/form_input_behavior"

RSpec.describe CommandPost::Form::Concerns::FormInputBehavior do
  let(:test_class) do
    Class.new do
      include CommandPost::Form::Concerns::FormInputBehavior

      def initialize(disabled: false, field: nil, current_user: nil)
        @disabled = disabled
        @field = field
        @current_user = current_user
      end
    end
  end

  describe "#effectively_disabled?" do
    context "when disabled is true" do
      it "returns true" do
        component = test_class.new(disabled: true)
        expect(component.effectively_disabled?).to be true
      end
    end

    context "when disabled is false and field is not readonly" do
      it "returns false" do
        component = test_class.new(disabled: false)
        expect(component.effectively_disabled?).to be false
      end
    end

    context "when disabled is false but field is readonly" do
      let(:readonly_field) { CommandPost::Field.new(:email, readonly: true) }

      it "returns true" do
        component = test_class.new(disabled: false, field: readonly_field)
        expect(component.effectively_disabled?).to be true
      end
    end

    context "when field uses proc for readonly" do
      let(:admin_user) { double("User", admin?: true) }
      let(:regular_user) { double("User", admin?: false) }
      let(:field) { CommandPost::Field.new(:email, readonly: ->(user) { !user.admin? }) }

      it "returns true for non-admin" do
        component = test_class.new(disabled: false, field: field, current_user: regular_user)
        expect(component.effectively_disabled?).to be true
      end

      it "returns false for admin" do
        component = test_class.new(disabled: false, field: field, current_user: admin_user)
        expect(component.effectively_disabled?).to be false
      end
    end
  end

  describe "#field_readonly?" do
    context "when no field is provided" do
      it "returns false" do
        component = test_class.new
        expect(component.field_readonly?).to be false
      end
    end

    context "when field is readonly" do
      let(:readonly_field) { CommandPost::Field.new(:email, readonly: true) }

      it "returns true" do
        component = test_class.new(field: readonly_field)
        expect(component.field_readonly?).to be true
      end
    end

    context "when field is not readonly" do
      let(:editable_field) { CommandPost::Field.new(:email, readonly: false) }

      it "returns false" do
        component = test_class.new(field: editable_field)
        expect(component.field_readonly?).to be false
      end
    end
  end

  describe "#theme" do
    it "returns the configuration theme" do
      component = test_class.new
      expect(component.theme).to eq(CommandPost.configuration.theme)
    end
  end

  describe "attr_readers" do
    it "exposes field" do
      field = CommandPost::Field.new(:email)
      component = test_class.new(field: field)
      expect(component.field).to eq(field)
    end

    it "exposes current_user" do
      user = double("User")
      component = test_class.new(current_user: user)
      expect(component.current_user).to eq(user)
    end

    it "exposes disabled" do
      component = test_class.new(disabled: true)
      expect(component.disabled).to be true
    end
  end
end
