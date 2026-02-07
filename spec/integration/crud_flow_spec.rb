# frozen_string_literal: true

require "rails_helper"

RSpec.describe "CRUD Flow", type: :request do
  before do
    CommandPost::ResourceRegistry.register(UserResource)
  end

  describe "complete CRUD lifecycle" do
    it "creates, reads, updates, and deletes a record" do
      # CREATE
      post command_post.resources_path("users"),
           params: { record: { name: "John Doe", email: "john@example.com", role: "admin" } }

      expect(response).to redirect_to(%r{/users/\d+})
      follow_redirect!
      expect(response.body).to include("John Doe")

      user = User.find_by(email: "john@example.com")
      expect(user).to be_present

      # READ (index)
      get command_post.resources_path("users")
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("John Doe")

      # READ (show)
      get command_post.resource_path("users", user)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("john@example.com")

      # UPDATE
      patch command_post.resource_path("users", user),
            params: { record: { name: "Jane Doe", email: "jane@example.com", role: "admin" } }

      expect(response).to redirect_to(command_post.resource_path("users", user))
      user.reload
      expect(user.name).to eq("Jane Doe")
      expect(user.email).to eq("jane@example.com")

      # DELETE
      delete command_post.resource_path("users", user)
      expect(response).to redirect_to(command_post.resources_path("users"))
      expect(User.find_by(id: user.id)).to be_nil
    end
  end

  describe "form validation" do
    it "shows errors on invalid create" do
      post command_post.resources_path("users"),
           params: { record: { name: "", email: "", role: "admin" } }

      expect(response).to have_http_status(:unprocessable_content)
    end

    it "shows errors on invalid update" do
      user = create(:user)

      patch command_post.resource_path("users", user),
            params: { record: { name: "", email: "", role: user.role } }

      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "navigation flow" do
    it "navigates from index to new to create to show" do
      # Index page
      get command_post.resources_path("users")
      expect(response).to have_http_status(:ok)

      # New page
      get command_post.new_resource_path("users")
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("form")

      # Create
      post command_post.resources_path("users"),
           params: { record: { name: "Test User", email: "test@example.com", role: "user" } }

      follow_redirect!
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Test User")
    end

    it "navigates from show to edit to update" do
      user = create(:user, name: "Original Name")

      # Show page
      get command_post.resource_path("users", user)
      expect(response).to have_http_status(:ok)

      # Edit page
      get command_post.edit_resource_path("users", user)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Original Name")

      # Update
      patch command_post.resource_path("users", user),
            params: { record: { name: "Updated Name", email: user.email, role: user.role } }

      follow_redirect!
      expect(response.body).to include("Updated Name")
    end
  end
end
