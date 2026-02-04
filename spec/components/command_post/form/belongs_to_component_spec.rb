require "rails_helper"
require_relative "../../../../app/components/command_post/form/belongs_to_component"

RSpec.describe CommandPost::Form::BelongsToComponent, type: :component do
  describe "#initialize" do
    it "stores name" do
      component = described_class.new(name: :user_id, association_class: User)
      expect(component.name).to eq(:user_id)
    end

    it "stores association_class" do
      component = described_class.new(name: :user_id, association_class: User)
      expect(component.association_class).to eq(User)
    end

    it "defaults selected to nil" do
      component = described_class.new(name: :user_id, association_class: User)
      expect(component.selected).to be_nil
    end

    it "defaults display_method to :name" do
      component = described_class.new(name: :user_id, association_class: User)
      expect(component.display_method).to eq(:name)
    end

    it "defaults include_blank to true" do
      component = described_class.new(name: :user_id, association_class: User)
      expect(component.include_blank).to be true
    end

    it "defaults disabled to false" do
      component = described_class.new(name: :user_id, association_class: User)
      expect(component.disabled).to be false
    end

    it "defaults has_error to false" do
      component = described_class.new(name: :user_id, association_class: User)
      expect(component.has_error).to be false
    end

    it "accepts all options" do
      component = described_class.new(
        name: :user_id,
        association_class: User,
        selected: 1,
        display_method: :email,
        include_blank: false,
        disabled: true,
        has_error: true
      )
      expect(component.selected).to eq(1)
      expect(component.display_method).to eq(:email)
      expect(component.include_blank).to be false
      expect(component.disabled).to be true
      expect(component.has_error).to be true
    end
  end

  describe "#options" do
    it "returns array of display/id pairs" do
      user = create(:user, name: "Test User")
      component = described_class.new(name: :user_id, association_class: User)
      options = component.options
      expect(options).to include(["Test User", user.id])
    end

    it "uses display_method to get label" do
      create(:user, email: "test@example.com")
      component = described_class.new(name: :user_id, association_class: User, display_method: :email)
      options = component.options
      expect(options.flatten).to include("test@example.com")
    end
  end

  describe "#select_classes" do
    it "includes w-full" do
      component = described_class.new(name: :user_id, association_class: User)
      expect(component.select_classes).to include("w-full")
    end

    it "includes appearance-none" do
      component = described_class.new(name: :user_id, association_class: User)
      expect(component.select_classes).to include("appearance-none")
    end

    it "includes border" do
      component = described_class.new(name: :user_id, association_class: User)
      expect(component.select_classes).to include("border")
    end

    it "includes error classes when has_error" do
      component = described_class.new(name: :user_id, association_class: User, has_error: true)
      expect(component.select_classes).to include("border-red-400")
    end

    it "includes disabled classes when disabled" do
      component = described_class.new(name: :user_id, association_class: User, disabled: true)
      expect(component.select_classes).to include("cursor-not-allowed")
    end
  end

  describe "#chevron_style" do
    it "includes background-image" do
      component = described_class.new(name: :user_id, association_class: User)
      expect(component.chevron_style).to include("background-image")
    end

    it "includes padding-right" do
      component = described_class.new(name: :user_id, association_class: User)
      expect(component.chevron_style).to include("padding-right")
    end
  end
end
