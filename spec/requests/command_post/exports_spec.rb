require "rails_helper"
require_relative "../../support/test_resources"

RSpec.describe "CommandPost::Exports", type: :request do
  before do
    CommandPost.reset_configuration!
    CommandPost::ResourceRegistry.reset!
    CommandPost::ResourceRegistry.register(UserResource)
  end

  describe "GET /:resource_name/export.csv" do
    it "returns CSV" do
      create(:user, name: "John", email: "john@test.com")

      get command_post.export_path("users", format: :csv)

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include("text/csv")
      expect(response.body).to include("john@test.com")
    end

    it "formats datetime fields as ISO8601" do
      user = create(:user, name: "John", email: "john@test.com")

      get command_post.export_path("users", format: :csv)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(user.created_at.iso8601)
    end

    it "formats boolean fields as Yes/No" do
      create(:user, name: "John", email: "john@test.com", active: true)
      create(:user, name: "Jane", email: "jane@test.com", active: false)

      get command_post.export_path("users", format: :csv)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Yes")
      expect(response.body).to include("No")
    end

    it "handles nil values gracefully" do
      create(:user, name: "John", email: "john@test.com", role: nil)

      get command_post.export_path("users", format: :csv)

      expect(response).to have_http_status(:ok)
      # Should not crash and should return empty string for nil
    end

    context "when field does not exist on record" do
      it "returns error message instead of crashing" do
        create(:user, name: "John", email: "john@test.com")
        # Stub resolved_fields to include a non-existent field
        fake_field = CommandPost::Field.new(:nonexistent_field, type: :text)
        allow(UserResource).to receive(:resolved_fields).and_return([fake_field])

        get command_post.export_path("users", format: :csv)

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("[Error: field not found]")
      end
    end
  end

  describe "GET /:resource_name/export.json" do
    it "returns JSON" do
      create(:user, name: "John", email: "john@test.com")

      get command_post.export_path("users", format: :json)

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include("application/json")
    end

    it "formats datetime fields as ISO8601" do
      user = create(:user, name: "John", email: "john@test.com")

      get command_post.export_path("users", format: :json)

      json = JSON.parse(response.body)
      expect(json.first["created_at"]).to eq(user.created_at.iso8601)
    end

    it "formats boolean fields as Yes/No" do
      create(:user, name: "John", email: "john@test.com", active: true)

      get command_post.export_path("users", format: :json)

      json = JSON.parse(response.body)
      expect(json.first["active"]).to eq("Yes")
    end

    it "handles nil values gracefully" do
      create(:user, name: "John", email: "john@test.com", role: nil)

      get command_post.export_path("users", format: :json)

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json.first["role"]).to eq("")
    end

    context "when field does not exist on record" do
      it "returns error message instead of crashing" do
        create(:user, name: "John", email: "john@test.com")
        # Stub resolved_fields to include a non-existent field
        fake_field = CommandPost::Field.new(:nonexistent_field, type: :text)
        allow(UserResource).to receive(:resolved_fields).and_return([fake_field])

        get command_post.export_path("users", format: :json)

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json.first["nonexistent_field"]).to eq("[Error: field not found]")
      end
    end
  end
end
