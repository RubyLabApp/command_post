# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Custom field types", type: :request do
  before do
    CommandPost::ResourceRegistry.register(UserResource)
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
end
