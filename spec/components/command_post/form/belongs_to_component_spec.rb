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

    it "defaults options_limit to DEFAULT_OPTIONS_LIMIT" do
      component = described_class.new(name: :user_id, association_class: User)
      expect(component.options_limit).to eq(described_class::DEFAULT_OPTIONS_LIMIT)
    end

    it "accepts custom options_limit" do
      component = described_class.new(name: :user_id, association_class: User, options_limit: 50)
      expect(component.options_limit).to eq(50)
    end

    it "defaults options_scope to nil" do
      component = described_class.new(name: :user_id, association_class: User)
      expect(component.options_scope).to be_nil
    end

    it "accepts custom options_scope" do
      scope = -> { where(role: "admin") }
      component = described_class.new(name: :user_id, association_class: User, options_scope: scope)
      expect(component.options_scope).to eq(scope)
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

    it "limits options to options_limit" do
      create_list(:user, 5)
      component = described_class.new(name: :user_id, association_class: User, options_limit: 3)
      expect(component.options.size).to eq(3)
    end

    it "applies custom options_scope" do
      create(:user, role: "admin", name: "Admin User")
      create(:user, role: "member", name: "Member User")
      scope = -> { where(role: "admin") }
      component = described_class.new(name: :user_id, association_class: User, options_scope: scope)
      options = component.options
      expect(options.size).to eq(1)
      expect(options.first.first).to eq("Admin User")
    end

    it "applies both options_scope and options_limit" do
      create_list(:user, 5, role: "admin")
      create_list(:user, 3, role: "member")
      scope = -> { where(role: "admin") }
      component = described_class.new(name: :user_id, association_class: User, options_scope: scope, options_limit: 2)
      expect(component.options.size).to eq(2)
    end
  end

  describe "#show_search_hint?" do
    it "returns true when total records exceed options_limit" do
      create_list(:user, 5)
      component = described_class.new(name: :user_id, association_class: User, options_limit: 3)
      expect(component.show_search_hint?).to be true
    end

    it "returns false when total records are within options_limit" do
      create_list(:user, 2)
      component = described_class.new(name: :user_id, association_class: User, options_limit: 5)
      expect(component.show_search_hint?).to be false
    end

    it "returns false when total records equal options_limit" do
      create_list(:user, 3)
      component = described_class.new(name: :user_id, association_class: User, options_limit: 3)
      expect(component.show_search_hint?).to be false
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
