# frozen_string_literal: true

require "rails_helper"

RSpec.describe "i18n support", type: :request do
  before do
    IronAdmin::ResourceRegistry.register(UserResource)
  end

  describe "flash messages" do
    it "uses i18n for create success" do
      post resources_path("users"), params: { record: { name: "Test", email: "i18n@test.com" } }
      expect(flash[:notice]).to eq("User created.")
    end

    it "uses i18n for update success" do
      user = User.create!(name: "Test", email: "i18n@test.com")
      patch resource_path("users", user), params: { record: { name: "Updated" } }
      expect(flash[:notice]).to eq("User updated.")
    end

    it "uses i18n for destroy success" do
      user = User.create!(name: "Test", email: "i18n@test.com")
      delete resource_path("users", user)
      expect(flash[:notice]).to eq("User deleted.")
    end
  end

  describe "index page strings" do
    it "renders translated search placeholder" do
      get resources_path("users")
      expect(response.body).to include("Search...")
    end

    it "renders translated empty state" do
      get resources_path("users")
      expect(response.body).to include("No records found.")
    end

    it "renders translated new button" do
      get resources_path("users")
      expect(response.body).to include("New User")
    end
  end

  describe "show page strings" do
    it "renders translated edit button" do
      user = User.create!(name: "Test", email: "i18n@test.com")
      get resource_path("users", user)
      expect(response.body).to include("Edit")
    end

    it "renders translated delete button" do
      user = User.create!(name: "Test", email: "i18n@test.com")
      get resource_path("users", user)
      expect(response.body).to include("Delete")
    end
  end
end
