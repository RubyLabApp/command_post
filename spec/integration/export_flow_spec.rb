# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Export Flow", type: :request do
  before do
    CommandPost::ResourceRegistry.register(UserResource)
  end

  let!(:users) do
    [
      create(:user, name: "Alice", email: "alice@example.com", role: "admin"),
      create(:user, name: "Bob", email: "bob@example.com", role: "user"),
      create(:user, name: "Charlie", email: "charlie@example.com", role: "user"),
    ]
  end

  describe "CSV export" do
    it "exports all records as CSV" do
      get command_post.export_path("users"), params: { format: :csv }

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include("text/csv")

      csv_content = response.body
      expect(csv_content).to include("Alice")
      expect(csv_content).to include("Bob")
      expect(csv_content).to include("Charlie")
    end

    it "includes headers in CSV" do
      get command_post.export_path("users"), params: { format: :csv }

      lines = response.body.lines
      header = lines.first

      expect(header).to include("Name")
      expect(header).to include("Email")
    end

    it "sets correct filename" do
      get command_post.export_path("users"), params: { format: :csv }

      disposition = response.headers["Content-Disposition"]
      expect(disposition).to include("users_")
      expect(disposition).to include(".csv")
    end
  end

  describe "JSON export" do
    it "exports all records as JSON" do
      get command_post.export_path("users"), params: { format: :json }

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include("application/json")

      json = JSON.parse(response.body)
      expect(json.length).to eq(3)
      expect(json.pluck("name")).to include("Alice", "Bob", "Charlie")
    end

    it "includes all exported fields" do
      get command_post.export_path("users"), params: { format: :json }

      json = JSON.parse(response.body)
      first_user = json.first

      expect(first_user).to have_key("name")
      expect(first_user).to have_key("email")
      expect(first_user).to have_key("role")
    end
  end

  describe "export with tenant scoping" do
    before do
      CommandPost.configure do |config|
        config.tenant_scope do |scope|
          scope.where(role: "user") # Only regular users
        end
      end
    end

    it "only exports records within tenant scope" do
      get command_post.export_path("users"), params: { format: :json }

      json = JSON.parse(response.body)
      names = json.pluck("name")

      expect(names).to include("Bob", "Charlie")
      expect(names).not_to include("Alice") # Admin excluded by tenant scope
    end
  end

  describe "export with field visibility" do
    let(:restricted_resource) do
      Class.new(CommandPost::Resource) do
        def self.name
          "RestrictedUserResource"
        end

        def self.model
          User
        end

        def self.resource_name
          "restricted_users"
        end

        field :email, visible: false
        field :secret_field, visible: ->(user) { user&.admin? }
      end
    end

    before do
      CommandPost::ResourceRegistry.register(restricted_resource)
    end

    it "excludes non-visible fields from export" do
      get command_post.export_path("restricted_users"), params: { format: :json }

      json = JSON.parse(response.body)
      first_user = json.first

      expect(first_user).not_to have_key("email")
    end
  end
end
