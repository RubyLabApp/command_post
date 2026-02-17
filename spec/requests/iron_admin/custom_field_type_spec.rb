# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Custom field types", type: :request do
  around do |example|
    original_field_overrides = IronAdmin::Resources::UserResource.field_overrides.dup
    original_index_field_names = IronAdmin::Resources::UserResource.index_field_names&.dup
    original_form_field_names = IronAdmin::Resources::UserResource.form_field_names&.dup
    IronAdmin::ResourceRegistry.register(IronAdmin::Resources::UserResource)
    example.run
  ensure
    IronAdmin::Resources::UserResource.field_overrides = original_field_overrides
    IronAdmin::Resources::UserResource.index_field_names = original_index_field_names
    IronAdmin::Resources::UserResource.form_field_names = original_form_field_names
  end

  describe "display on show page" do
    it "renders custom display block" do
      IronAdmin::FieldTypeRegistry.register(:star_rating) do
        display { |record, field| record.public_send(field.name) ? "★★★★★" : "☆☆☆☆☆" }
      end

      IronAdmin::Resources::UserResource.field :active, type: :star_rating

      user = User.create!(name: "Test", email: "test@example.com", active: true)
      get iron_admin.resource_path("users", user)

      expect(response.body).to include("★★★★★")
    end
  end

  describe "display on index page" do
    it "renders custom index_display block when defined" do
      IronAdmin::FieldTypeRegistry.register(:custom_text) do
        display { |record, field| "full: #{record.public_send(field.name)}" }
        index_display { |_record, _field| "short" }
      end

      IronAdmin::Resources::UserResource.field :name, type: :custom_text
      IronAdmin::Resources::UserResource.index_fields :name

      User.create!(name: "Test", email: "test@example.com")
      get iron_admin.resources_path("users")

      expect(response.body).to include("short")
    end
  end

  describe "fallback for unregistered types" do
    it "displays raw value for unknown types" do
      IronAdmin::Resources::UserResource.field :name, type: :totally_unknown
      IronAdmin::Resources::UserResource.index_fields :name

      User.create!(name: "RawValue", email: "raw@example.com")
      get iron_admin.resources_path("users")

      expect(response.body).to include("RawValue")
    end
  end

  describe "form rendering" do
    it "renders custom form partial when registered" do
      IronAdmin::FieldTypeRegistry.register(:custom_input) do
        display { |record, field| record.public_send(field.name) }
        form_partial "iron_admin/fields/custom_input"
      end

      IronAdmin::Resources::UserResource.field :name, type: :custom_input
      IronAdmin::Resources::UserResource.form_fields :name

      user = User.create!(name: "Test", email: "form@example.com")
      get iron_admin.edit_resource_path("users", user)

      expect(response.body).to include("custom-input-field")
    end

    it "falls back to text input when no form rendering registered" do
      IronAdmin::FieldTypeRegistry.register(:display_only) do
        display { |record, field| "custom: #{record.public_send(field.name)}" }
      end

      IronAdmin::Resources::UserResource.field :name, type: :display_only
      IronAdmin::Resources::UserResource.form_fields :name

      user = User.create!(name: "Test", email: "fallback@example.com")
      get iron_admin.edit_resource_path("users", user)

      expect(response.body).to include('type="text"')
    end
  end
end
