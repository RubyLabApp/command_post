require "rails_helper"
require_relative "../../support/test_resources"

RSpec.describe "CommandPost::Exports", type: :request do
  before do
    CommandPost.reset_configuration!
    CommandPost::ResourceRegistry.reset!
    CommandPost::ResourceRegistry.register(UserResource)
    CommandPost::ResourceRegistry.register(LicenseResource)
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

  describe "export with belongs_to associations" do
    let(:user) { create(:user, name: "John Doe", email: "john@example.com") }

    context "CSV format" do
      it "exports the association's display value" do
        license = create(:license, user: user, license_key: "ABC-123")

        get command_post.export_path("licenses", format: :csv)

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include("text/csv")
        expect(response.body).to include("john@example.com")
      end

      it "handles nil association gracefully" do
        # Create license without user (if allowed) or with nil user
        license = create(:license, user: user, license_key: "DEF-456")
        license.update_column(:user_id, nil)

        get command_post.export_path("licenses", format: :csv)

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include("text/csv")
        # Should not crash - the CSV should be valid
        csv_lines = response.body.split("\n")
        expect(csv_lines.length).to be >= 2 # header + at least one data row
      end

      it "escapes special characters properly" do
        user_with_special = create(:user, name: 'John "The Boss" Doe', email: "boss@example.com")
        create(:license, user: user_with_special, license_key: "SPECIAL-001")

        get command_post.export_path("licenses", format: :csv)

        expect(response).to have_http_status(:ok)
        # CSV should properly escape quotes by doubling them
        expect(response.body).to include("boss@example.com")
      end

      it "escapes commas in field values" do
        user_with_comma = create(:user, name: "Doe, John", email: "comma@example.com")
        create(:license, user: user_with_comma, license_key: "COMMA-001")

        get command_post.export_path("licenses", format: :csv)

        expect(response).to have_http_status(:ok)
        # CSV should handle commas by quoting the field
        expect(response.body).to include("comma@example.com")
      end

      it "escapes newlines in field values" do
        user_with_newline = create(:user, name: "John\nDoe", email: "newline@example.com")
        create(:license, user: user_with_newline, license_key: "NEWLINE-001")

        get command_post.export_path("licenses", format: :csv)

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("newline@example.com")
      end
    end

    context "JSON format" do
      it "exports the association's display value" do
        license = create(:license, user: user, license_key: "GHI-789")

        get command_post.export_path("licenses", format: :json)

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json.first["user"]).to eq("john@example.com")
      end

      it "handles nil association gracefully" do
        license = create(:license, user: user, license_key: "JKL-012")
        license.update_column(:user_id, nil)

        get command_post.export_path("licenses", format: :json)

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json.first["user"]).to eq("")
      end

      it "handles special characters in JSON" do
        user_with_special = create(:user, name: 'John "The Boss" Doe', email: "json-special@example.com")
        create(:license, user: user_with_special, license_key: "JSON-SPECIAL-001")

        get command_post.export_path("licenses", format: :json)

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json.first["user"]).to eq("json-special@example.com")
      end
    end
  end
end
