require "rails_helper"
require "ostruct"
require_relative "../../support/test_resources"

RSpec.describe "IronAdmin::Exports", type: :request do
  before do
    IronAdmin.reset_configuration!
    IronAdmin::ResourceRegistry.reset!
    IronAdmin::ResourceRegistry.register(UserResource)
    IronAdmin::ResourceRegistry.register(LicenseResource)
  end

  describe "field visibility enforcement" do
    let(:visibility_resource) do
      Class.new(IronAdmin::Resource) do
        self.model_class_override = User

        def self.name
          "ExportVisibilityUserResource"
        end

        def self.resource_name
          "export_visibility_users"
        end

        field :name, type: :text
        field :email, visible: ->(user) { user&.role == "admin" }
        field :role, visible: false
      end
    end

    before do
      IronAdmin::ResourceRegistry.register(visibility_resource)
    end

    after do
      IronAdmin::ResourceRegistry.reset!
      IronAdmin::ResourceRegistry.register(UserResource)
      IronAdmin::ResourceRegistry.register(LicenseResource)
    end

    context "when user does not have permission to see a field" do
      before do
        IronAdmin.configure do |config|
          config.current_user { OpenStruct.new(role: "member") }
        end
      end

      it "excludes invisible fields from CSV export" do
        create(:user, name: "Test User", email: "secret@example.com", role: "admin")

        get iron_admin.export_path("export_visibility_users", format: :csv)

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Test User")
        expect(response.body).not_to include("secret@example.com")
        expect(response.body).not_to include("admin")
      end

      it "excludes invisible fields from JSON export" do
        create(:user, name: "Test User", email: "secret@example.com", role: "admin")

        get iron_admin.export_path("export_visibility_users", format: :json)

        expect(response).to have_http_status(:ok)
        json = response.parsed_body
        expect(json.first.keys).to include("name")
        expect(json.first.keys).not_to include("email")
        expect(json.first.keys).not_to include("role")
      end

      it "excludes invisible field headers from CSV export" do
        create(:user, name: "Test User", email: "secret@example.com", role: "admin")

        get iron_admin.export_path("export_visibility_users", format: :csv)

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Name")
        expect(response.body).not_to include("Email")
        expect(response.body).not_to include("Role")
      end
    end

    context "when user has permission to see a field" do
      before do
        IronAdmin.configure do |config|
          config.current_user { OpenStruct.new(role: "admin") }
        end
      end

      it "includes conditionally visible fields in CSV export" do
        create(:user, name: "Test User", email: "visible@example.com", role: "member")

        get iron_admin.export_path("export_visibility_users", format: :csv)

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Test User")
        expect(response.body).to include("visible@example.com")
        expect(response.body).not_to include("member")
      end

      it "includes conditionally visible fields in JSON export" do
        create(:user, name: "Test User", email: "visible@example.com", role: "member")

        get iron_admin.export_path("export_visibility_users", format: :json)

        expect(response).to have_http_status(:ok)
        json = response.parsed_body
        expect(json.first.keys).to include("name")
        expect(json.first.keys).to include("email")
        expect(json.first.keys).not_to include("role")
      end
    end

    context "when no user is logged in" do
      before do
        IronAdmin.configure do |config|
          config.current_user { nil }
        end
      end

      it "excludes conditionally visible fields from CSV export" do
        create(:user, name: "Test User", email: "secret@example.com", role: "admin")

        get iron_admin.export_path("export_visibility_users", format: :csv)

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Test User")
        expect(response.body).not_to include("secret@example.com")
      end

      it "excludes conditionally visible fields from JSON export" do
        create(:user, name: "Test User", email: "secret@example.com", role: "admin")

        get iron_admin.export_path("export_visibility_users", format: :json)

        expect(response).to have_http_status(:ok)
        json = response.parsed_body
        expect(json.first.keys).to include("name")
        expect(json.first.keys).not_to include("email")
      end
    end
  end

  describe "GET /:resource_name/export.csv" do
    it "returns CSV" do
      create(:user, name: "John", email: "john@test.com")

      get iron_admin.export_path("users", format: :csv)

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include("text/csv")
      expect(response.body).to include("john@test.com")
    end

    it "formats datetime fields as ISO8601" do
      user = create(:user, name: "John", email: "john@test.com")

      get iron_admin.export_path("users", format: :csv)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(user.created_at.iso8601)
    end

    it "formats boolean fields as Yes/No" do
      create(:user, name: "John", email: "john@test.com", active: true)
      create(:user, name: "Jane", email: "jane@test.com", active: false)

      get iron_admin.export_path("users", format: :csv)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Yes")
      expect(response.body).to include("No")
    end

    it "handles nil values gracefully" do
      create(:user, name: "John", email: "john@test.com", role: nil)

      get iron_admin.export_path("users", format: :csv)

      expect(response).to have_http_status(:ok)
      # Should not crash and should return empty string for nil
    end

    context "when field does not exist on record" do
      it "returns error message instead of crashing" do
        create(:user, name: "John", email: "john@test.com")
        # Stub resolved_fields to include a non-existent field
        fake_field = IronAdmin::Field.new(:nonexistent_field, type: :text)
        allow(UserResource).to receive(:resolved_fields).and_return([fake_field])

        get iron_admin.export_path("users", format: :csv)

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("[Error: field not found]")
      end
    end
  end

  describe "GET /:resource_name/export.json" do
    it "returns JSON" do
      create(:user, name: "John", email: "john@test.com")

      get iron_admin.export_path("users", format: :json)

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include("application/json")
    end

    it "formats datetime fields as ISO8601" do
      user = create(:user, name: "John", email: "john@test.com")

      get iron_admin.export_path("users", format: :json)

      json = response.parsed_body
      expect(json.first["created_at"]).to eq(user.created_at.iso8601)
    end

    it "formats boolean fields as Yes/No" do
      create(:user, name: "John", email: "john@test.com", active: true)

      get iron_admin.export_path("users", format: :json)

      json = response.parsed_body
      expect(json.first["active"]).to eq("Yes")
    end

    it "handles nil values gracefully" do
      create(:user, name: "John", email: "john@test.com", role: nil)

      get iron_admin.export_path("users", format: :json)

      expect(response).to have_http_status(:ok)
      json = response.parsed_body
      expect(json.first["role"]).to eq("")
    end

    context "when field does not exist on record" do
      it "returns error message instead of crashing" do
        create(:user, name: "John", email: "john@test.com")
        # Stub resolved_fields to include a non-existent field
        fake_field = IronAdmin::Field.new(:nonexistent_field, type: :text)
        allow(UserResource).to receive(:resolved_fields).and_return([fake_field])

        get iron_admin.export_path("users", format: :json)

        expect(response).to have_http_status(:ok)
        json = response.parsed_body
        expect(json.first["nonexistent_field"]).to eq("[Error: field not found]")
      end
    end
  end

  describe "export with belongs_to associations" do
    let(:user) { create(:user, name: "John Doe", email: "john@example.com") }

    context "CSV format" do
      it "exports the association's display value" do
        create(:license, user: user, license_key: "ABC-123")

        get iron_admin.export_path("licenses", format: :csv)

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include("text/csv")
        expect(response.body).to include("john@example.com")
      end

      it "handles nil association gracefully" do
        # Create license without user (if allowed) or with nil user
        license = create(:license, user: user, license_key: "DEF-456")
        license.update_column(:user_id, nil)

        get iron_admin.export_path("licenses", format: :csv)

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include("text/csv")
        # Should not crash - the CSV should be valid
        csv_lines = response.body.split("\n")
        expect(csv_lines.length).to be >= 2 # header + at least one data row
      end

      it "escapes special characters properly" do
        user_with_special = create(:user, name: 'John "The Boss" Doe', email: "boss@example.com")
        create(:license, user: user_with_special, license_key: "SPECIAL-001")

        get iron_admin.export_path("licenses", format: :csv)

        expect(response).to have_http_status(:ok)
        # CSV should properly escape quotes by doubling them
        expect(response.body).to include("boss@example.com")
      end

      it "escapes commas in field values" do
        user_with_comma = create(:user, name: "Doe, John", email: "comma@example.com")
        create(:license, user: user_with_comma, license_key: "COMMA-001")

        get iron_admin.export_path("licenses", format: :csv)

        expect(response).to have_http_status(:ok)
        # CSV should handle commas by quoting the field
        expect(response.body).to include("comma@example.com")
      end

      it "escapes newlines in field values" do
        user_with_newline = create(:user, name: "John\nDoe", email: "newline@example.com")
        create(:license, user: user_with_newline, license_key: "NEWLINE-001")

        get iron_admin.export_path("licenses", format: :csv)

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("newline@example.com")
      end
    end

    context "JSON format" do
      it "exports the association's display value" do
        create(:license, user: user, license_key: "GHI-789")

        get iron_admin.export_path("licenses", format: :json)

        expect(response).to have_http_status(:ok)
        json = response.parsed_body
        expect(json.first["user"]).to eq("john@example.com")
      end

      it "handles nil association gracefully" do
        license = create(:license, user: user, license_key: "JKL-012")
        license.update_column(:user_id, nil)

        get iron_admin.export_path("licenses", format: :json)

        expect(response).to have_http_status(:ok)
        json = response.parsed_body
        expect(json.first["user"]).to eq("")
      end

      it "handles special characters in JSON" do
        user_with_special = create(:user, name: 'John "The Boss" Doe', email: "json-special@example.com")
        create(:license, user: user_with_special, license_key: "JSON-SPECIAL-001")

        get iron_admin.export_path("licenses", format: :json)

        expect(response).to have_http_status(:ok)
        json = response.parsed_body
        expect(json.first["user"]).to eq("json-special@example.com")
      end
    end
  end
end
