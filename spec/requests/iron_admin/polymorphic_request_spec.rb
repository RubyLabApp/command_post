# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Polymorphic associations requests", type: :request do
  before do
    IronAdmin::ResourceRegistry.register(UserResource)
    IronAdmin::ResourceRegistry.register(LicenseResource)
    IronAdmin::ResourceRegistry.register(NoteResource)
  end

  describe "show page" do
    it "displays polymorphic association as link" do
      user = User.create!(name: "Test User", email: "poly@test.com")
      note = Note.create!(title: "Test Note", notable: user)

      get resource_path("notes", note)
      expect(response.body).to include("Test User")
      expect(response.body).to include(resource_path("users", user))
    end

    it "handles nil polymorphic association" do
      note = Note.create!(title: "Orphan Note")

      get resource_path("notes", note)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "form" do
    it "renders type and id selects" do
      note = Note.create!(title: "Test Note")
      get edit_resource_path("notes", note)

      expect(response.body).to include("notable_type")
      expect(response.body).to include("notable_id")
    end
  end

  describe "create with polymorphic params" do
    it "saves polymorphic association" do
      user = User.create!(name: "Test User", email: "poly@create.com")

      post resources_path("notes"), params: {
        record: { title: "New Note", notable_type: "User", notable_id: user.id },
      }

      note = Note.last
      expect(note.notable).to eq(user)
    end
  end

  describe "index page" do
    it "displays polymorphic type and label" do
      user = User.create!(name: "Test User", email: "poly@index.com")
      Note.create!(title: "Test Note", notable: user)

      get resources_path("notes")
      expect(response.body).to include("Test User")
    end
  end
end
