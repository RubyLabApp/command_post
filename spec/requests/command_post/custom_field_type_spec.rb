# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Custom field types", type: :request do
  around do |example|
    original_field_overrides = UserResource.field_overrides.dup
    original_index_field_names = UserResource.index_field_names&.dup
    original_form_field_names = UserResource.form_field_names&.dup
    CommandPost::ResourceRegistry.register(UserResource)
    example.run
  ensure
    UserResource.field_overrides = original_field_overrides
    UserResource.index_field_names = original_index_field_names
    UserResource.form_field_names = original_form_field_names
  end

  describe "display on show page" do
    it "renders custom display block" do
      CommandPost::FieldTypeRegistry.register(:star_rating) do
        display { |record, field| record.public_send(field.name) ? "★★★★★" : "☆☆☆☆☆" }
      end

      UserResource.field :active, type: :star_rating

      user = User.create!(name: "Test", email: "test@example.com", active: true)
      get command_post.resource_path("users", user)

      expect(response.body).to include("★★★★★")
    end
  end

  describe "display on index page" do
    it "renders custom index_display block when defined" do
      CommandPost::FieldTypeRegistry.register(:custom_text) do
        display { |record, field| "full: #{record.public_send(field.name)}" }
        index_display { |_record, _field| "short" }
      end

      UserResource.field :name, type: :custom_text
      UserResource.index_fields :name

      User.create!(name: "Test", email: "test@example.com")
      get command_post.resources_path("users")

      expect(response.body).to include("short")
    end
  end

  describe "fallback for unregistered types" do
    it "displays raw value for unknown types" do
      UserResource.field :name, type: :totally_unknown
      UserResource.index_fields :name

      User.create!(name: "RawValue", email: "raw@example.com")
      get command_post.resources_path("users")

      expect(response.body).to include("RawValue")
    end
  end

  describe "form rendering" do
    it "renders custom form partial when registered" do
      CommandPost::FieldTypeRegistry.register(:custom_input) do
        display { |record, field| record.public_send(field.name) }
        form_partial "command_post/fields/custom_input"
      end

      UserResource.field :name, type: :custom_input
      UserResource.form_fields :name

      user = User.create!(name: "Test", email: "form@example.com")
      get command_post.edit_resource_path("users", user)

      expect(response.body).to include("custom-input-field")
    end

    it "falls back to text input when no form rendering registered" do
      CommandPost::FieldTypeRegistry.register(:display_only) do
        display { |record, field| "custom: #{record.public_send(field.name)}" }
      end

      UserResource.field :name, type: :display_only
      UserResource.form_fields :name

      user = User.create!(name: "Test", email: "fallback@example.com")
      get command_post.edit_resource_path("users", user)

      expect(response.body).to include('type="text"')
    end
  end
end
