# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Search Flow", type: :request do
  before do
    IronAdmin::ResourceRegistry.register(UserResource)
  end

  let!(:john) { create(:user, name: "John Smith", email: "john@example.com", role: "admin") }
  let!(:jane) { create(:user, name: "Jane Doe", email: "jane@company.org", role: "user") }
  let!(:bob) { create(:user, name: "Bob Johnson", email: "bob@example.com", role: "admin") }

  describe "general search" do
    it "finds records by name" do
      get iron_admin.resources_path("users"), params: { q: "John" }

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("John Smith")
      expect(response.body).to include("Bob Johnson")
      expect(response.body).not_to include("Jane Doe")
    end

    it "finds records by email" do
      get iron_admin.resources_path("users"), params: { q: "example.com" }

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("John Smith")
      expect(response.body).to include("Bob Johnson")
      expect(response.body).not_to include("Jane Doe")
    end

    it "returns all records with empty search" do
      get iron_admin.resources_path("users"), params: { q: "" }

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("John Smith")
      expect(response.body).to include("Jane Doe")
      expect(response.body).to include("Bob Johnson")
    end

    it "returns no records with non-matching search" do
      get iron_admin.resources_path("users"), params: { q: "nonexistent_xyz_123" }

      expect(response).to have_http_status(:ok)
      expect(response.body).not_to include("John Smith")
      expect(response.body).not_to include("Jane Doe")
    end
  end

  describe "field-specific search" do
    it "searches by specific field" do
      get iron_admin.resources_path("users"), params: { q: "email:john@example.com" }

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("John Smith")
      expect(response.body).not_to include("Jane Doe")
      expect(response.body).not_to include("Bob Johnson")
    end

    it "searches by name field" do
      get iron_admin.resources_path("users"), params: { q: "name:Jane" }

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Jane Doe")
      expect(response.body).not_to include("John Smith")
    end
  end

  describe "search with special characters" do
    it "handles search with special characters safely" do
      get iron_admin.resources_path("users"), params: { q: "test'; DROP TABLE users;--" }

      expect(response).to have_http_status(:ok)
      expect(User.count).to eq(3) # Table not dropped
    end

    it "handles unicode characters" do
      create(:user, name: "José García", email: "jose@example.com")

      get iron_admin.resources_path("users"), params: { q: "José" }

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("José García")
    end

    it "handles percent signs" do
      get iron_admin.resources_path("users"), params: { q: "100%" }

      expect(response).to have_http_status(:ok)
      # Should not error
    end
  end

  describe "search combined with filters" do
    it "applies search and filter together" do
      get iron_admin.resources_path("users"),
          params: { q: "example.com", filters: { role: "admin" } }

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("John Smith")
      expect(response.body).to include("Bob Johnson")
      expect(response.body).not_to include("Jane Doe")
    end
  end

  describe "search combined with sorting" do
    it "applies search and sorting together" do
      get iron_admin.resources_path("users"),
          params: { q: "example.com", sort: "name", direction: "asc" }

      expect(response).to have_http_status(:ok)
      body = response.body
      bob_pos = body.index("Bob Johnson")
      john_pos = body.index("John Smith")
      expect(bob_pos).to be < john_pos
    end
  end
end
