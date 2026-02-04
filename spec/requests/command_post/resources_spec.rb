require "rails_helper"
require_relative "../../support/test_resources"

RSpec.describe "CommandPost::Resources", type: :request do
  before do
    CommandPost.reset_configuration!
    CommandPost::ResourceRegistry.reset!
    CommandPost::ResourceRegistry.register(UserResource)
    CommandPost::ResourceRegistry.register(LicenseResource)
  end

  describe "GET /:resource_name" do
    it "returns success" do
      create_list(:user, 3)
      get command_post.resources_path("users"), headers: { "Accept" => "text/html" }
      expect(response).to have_http_status(:ok)
    end

    context "with search query" do
      it "filters records by search term" do
        create(:user, name: "John Doe", email: "john@example.com")
        create(:user, name: "Jane Smith", email: "jane@example.com")
        get command_post.resources_path("users"), params: { q: "John" }, as: :html
        expect(response).to have_http_status(:ok)
      end
    end

    context "with sorting" do
      it "sorts records by column" do
        create_list(:user, 3)
        get command_post.resources_path("users"), params: { sort: "name", direction: "asc" }, as: :html
        expect(response).to have_http_status(:ok)
      end

      it "uses default sorting for invalid columns" do
        create_list(:user, 3)
        get command_post.resources_path("users"), params: { sort: "invalid_column" }, as: :html
        expect(response).to have_http_status(:ok)
      end
    end

    context "with filters" do
      it "filters records by select filter" do
        create(:user, role: "admin")
        create(:user, role: "member")
        get command_post.resources_path("users"), params: { filters: { role: "admin" } }, as: :html
        expect(response).to have_http_status(:ok)
      end
    end

    context "with scopes" do
      let(:user) { create(:user) }

      before do
        create(:license, user: user, status: "active")
        create(:license, user: user, status: "expired")
      end

      it "applies the specified scope" do
        get command_post.resources_path("licenses"), params: { scope: "expired" }, as: :html
        expect(response).to have_http_status(:ok)
      end

      it "applies the default scope when none specified" do
        get command_post.resources_path("licenses"), as: :html
        expect(response).to have_http_status(:ok)
      end
    end

    context "with date range filter" do
      let(:user) { create(:user) }

      it "filters by date range" do
        create(:license, user: user, created_at: 1.day.ago)
        create(:license, user: user, created_at: 10.days.ago)
        get command_post.resources_path("licenses"),
            params: { filters: { created_at_from: 5.days.ago.to_date, created_at_to: Date.current } },
            as: :html
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "GET /:resource_name/:id" do
    it "shows a record" do
      user = create(:user)
      get command_post.resource_path("users", user), as: :html
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /:resource_name/new" do
    it "shows new form" do
      get command_post.new_resource_path("users"), as: :html
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /:resource_name/:id/edit" do
    it "shows edit form" do
      user = create(:user)
      get command_post.edit_resource_path("users", user), as: :html
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /:resource_name" do
    context "with valid params" do
      it "creates a new record" do
        expect do
          post command_post.resources_path("users"),
               params: { record: { name: "New User", email: "new@example.com", role: "member" } },
               as: :html
        end.to change(User, :count).by(1)
      end

      it "redirects to the show page" do
        post command_post.resources_path("users"),
             params: { record: { name: "New User", email: "new@example.com", role: "member" } },
             as: :html
        expect(response).to redirect_to(command_post.resource_path("users", User.last))
      end
    end

    context "with invalid params" do
      before do
        User.class_eval do
          validates :email, presence: true
        end
      end

      after do
        User.clear_validators!
      end

      it "renders new form with errors" do
        post command_post.resources_path("users"),
             params: { record: { name: "User", email: "", role: "member" } },
             as: :html
        expect(response).to have_http_status(:unprocessable_content)
      end
    end

    context "with on_action callback" do
      it "emits create event" do
        events = []
        CommandPost.configure do |config|
          config.on_action { |event| events << event }
        end

        post command_post.resources_path("users"),
             params: { record: { name: "New User", email: "new@example.com", role: "member" } },
             as: :html

        expect(events.last.action).to eq(:create)
      end
    end
  end

  describe "PATCH /:resource_name/:id" do
    let(:user) { create(:user, name: "Old Name") }

    context "with valid params" do
      it "updates the record" do
        patch command_post.resource_path("users", user),
              params: { record: { name: "New Name", email: user.email, role: user.role } },
              as: :html
        expect(user.reload.name).to eq("New Name")
      end

      it "redirects to the show page" do
        patch command_post.resource_path("users", user),
              params: { record: { name: "New Name", email: user.email, role: user.role } },
              as: :html
        expect(response).to redirect_to(command_post.resource_path("users", user))
      end
    end

    context "with invalid params" do
      before do
        User.class_eval do
          validates :email, presence: true
        end
      end

      after do
        User.clear_validators!
      end

      it "renders edit form with errors" do
        patch command_post.resource_path("users", user),
              params: { record: { name: "Name", email: "", role: "member" } },
              as: :html
        expect(response).to have_http_status(:unprocessable_content)
      end
    end

    context "with on_action callback" do
      it "emits update event" do
        events = []
        CommandPost.configure do |config|
          config.on_action { |event| events << event }
        end

        patch command_post.resource_path("users", user),
              params: { record: { name: "New Name", email: user.email, role: user.role } },
              as: :html

        expect(events.last.action).to eq(:update)
      end
    end
  end

  describe "DELETE /:resource_name/:id" do
    let!(:user) { create(:user) }

    it "destroys the record" do
      expect do
        delete command_post.resource_path("users", user), as: :html
      end.to change(User, :count).by(-1)
    end

    it "redirects to index" do
      delete command_post.resource_path("users", user), as: :html
      expect(response).to redirect_to(command_post.resources_path("users"))
    end

    context "with on_action callback" do
      it "emits destroy event" do
        events = []
        CommandPost.configure do |config|
          config.on_action { |event| events << event }
        end

        delete command_post.resource_path("users", user), as: :html
        expect(events.last.action).to eq(:destroy)
      end
    end
  end

  describe "POST /:resource_name/:id/actions/:action_name" do
    let(:user) { create(:user) }
    let!(:license) { create(:license, user: user, status: "active") }

    context "with valid action" do
      it "executes the action" do
        post command_post.resource_action_path("licenses", license, "revoke"), as: :html
        expect(license.reload.status).to eq("revoked")
      end

      it "redirects to show page" do
        post command_post.resource_action_path("licenses", license, "revoke"), as: :html
        expect(response).to redirect_to(command_post.resource_path("licenses", license))
      end
    end

    context "with invalid action" do
      it "returns not found" do
        post command_post.resource_action_path("licenses", license, "nonexistent"), as: :html
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "POST /:resource_name/bulk_actions/:action_name" do
    let(:user) { create(:user) }
    let!(:licenses) { create_list(:license, 3, user: user) }

    context "with valid bulk action" do
      it "executes the bulk action" do
        post command_post.resource_bulk_action_path("licenses", "export"),
             params: { ids: licenses.map(&:id) },
             as: :html
        expect(response).to redirect_to(command_post.resources_path("licenses"))
        expect(flash[:notice]).to eq("Bulk action executed.")
      end
    end

    context "with invalid bulk action" do
      it "returns not found" do
        post command_post.resource_bulk_action_path("licenses", "nonexistent"),
             params: { ids: licenses.map(&:id) },
             as: :html
        expect(response).to have_http_status(:not_found)
      end
    end

    context "without ids" do
      it "handles empty ids" do
        post command_post.resource_bulk_action_path("licenses", "export"), as: :html
        expect(response).to redirect_to(command_post.resources_path("licenses"))
      end
    end
  end

  describe "resource not found" do
    it "returns not found for unknown resource" do
      get command_post.resources_path("unknown_resources"), as: :html
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "association preloading" do
    let(:user) { create(:user) }

    before do
      create_list(:license, 3, user: user)
    end

    it "preloads belongs_to associations to prevent N+1 queries" do
      # LicenseResource has belongs_to :user, which should be preloaded
      queries = []
      callback = lambda { |_name, _start, _finish, _id, payload|
        queries << payload[:sql] unless payload[:sql].match?(/SCHEMA|TRANSACTION/)
      }

      ActiveSupport::Notifications.subscribed(callback, "sql.active_record") do
        get command_post.resources_path("licenses"), headers: { "Accept" => "text/html" }
      end

      expect(response).to have_http_status(:ok)

      # Count queries that select from users table
      # Without preloading: we'd see 1 query for licenses + 3 queries for each user
      # With preloading: we'd see 1 query for licenses + 1 query for all users
      user_queries = queries.select { |q| q.include?('"users"') || q.include?('`users`') }
      expect(user_queries.length).to be <= 1
    end

    it "applies custom preload associations when defined" do
      custom_resource = Class.new(CommandPost::Resource) do
        self.model_class_override = License

        def self.name
          "CustomPreloadLicenseResource"
        end

        def self.resource_name
          "custom_preload_licenses"
        end

        belongs_to :user, display: :email
        preload :user
      end

      CommandPost::ResourceRegistry.register(custom_resource)

      queries = []
      callback = lambda { |_name, _start, _finish, _id, payload|
        queries << payload[:sql] unless payload[:sql].match?(/SCHEMA|TRANSACTION/)
      }

      ActiveSupport::Notifications.subscribed(callback, "sql.active_record") do
        get command_post.resources_path("custom_preload_licenses"), headers: { "Accept" => "text/html" }
      end

      expect(response).to have_http_status(:ok)

      # Verify user association is preloaded
      user_queries = queries.select { |q| q.include?('"users"') || q.include?('`users`') }
      expect(user_queries.length).to be <= 1
    end
  end

  describe "field visibility enforcement" do
    # Create a resource with a field that has conditional visibility
    let(:visibility_resource) do
      Class.new(CommandPost::Resource) do
        self.model_class_override = User

        def self.name
          "VisibilityUserResource"
        end

        def self.resource_name
          "visibility_users"
        end

        # Make email invisible to non-admin users
        field :email, visible: ->(user) { user&.role == "admin" }
        # Make role always invisible
        field :role, visible: false

        index_fields :id, :name, :email, :role
      end
    end

    before do
      CommandPost::ResourceRegistry.register(visibility_resource)
    end

    after do
      CommandPost::ResourceRegistry.reset!
      CommandPost::ResourceRegistry.register(UserResource)
      CommandPost::ResourceRegistry.register(LicenseResource)
    end

    context "when user does not have permission to see a field" do
      before do
        CommandPost.configure do |config|
          config.current_user { OpenStruct.new(role: "member") }
        end
      end

      it "does not show invisible fields in index view" do
        user = create(:user, name: "Test User", email: "test@example.com", role: "admin")
        get command_post.resources_path("visibility_users"), headers: { "Accept" => "text/html" }

        expect(response).to have_http_status(:ok)
        # The email field should not be visible to non-admin users
        expect(response.body).not_to include("Email")
        # The role field is always invisible
        expect(response.body).not_to include(">Role<")
        # The name field should be visible
        expect(response.body).to include("Name")
        # The actual email value should not appear
        expect(response.body).not_to include("test@example.com")
      end

      it "does not show invisible fields in show view" do
        user = create(:user, name: "Test User", email: "test@example.com", role: "admin")
        get command_post.resource_path("visibility_users", user), headers: { "Accept" => "text/html" }

        expect(response).to have_http_status(:ok)
        # The email field should not be visible to non-admin users
        expect(response.body).not_to include("test@example.com")
        # The name should be visible
        expect(response.body).to include("Test User")
      end
    end

    context "when user has permission to see a field" do
      before do
        CommandPost.configure do |config|
          config.current_user { OpenStruct.new(role: "admin") }
        end
      end

      it "shows conditionally visible fields in index view" do
        user = create(:user, name: "Test User", email: "test@example.com", role: "member")
        get command_post.resources_path("visibility_users"), headers: { "Accept" => "text/html" }

        expect(response).to have_http_status(:ok)
        # The email field should be visible to admin users
        expect(response.body).to include("Email")
        expect(response.body).to include("test@example.com")
        # The role field is always invisible (visible: false)
        expect(response.body).not_to include(">Role<")
        # The name field should be visible
        expect(response.body).to include("Name")
      end

      it "shows conditionally visible fields in show view" do
        user = create(:user, name: "Test User", email: "test@example.com", role: "member")
        get command_post.resource_path("visibility_users", user), headers: { "Accept" => "text/html" }

        expect(response).to have_http_status(:ok)
        # Admin user should see the email field
        expect(response.body).to include("test@example.com")
        # The name should be visible
        expect(response.body).to include("Test User")
      end
    end
  end

  describe "policy-based authorization" do
    # Create a resource with a policy that only allows admin users
    let(:policy_user_resource) do
      Class.new(CommandPost::Resource) do
        self.model_class_override = User

        def self.name
          "PolicyUserResource"
        end

        def self.resource_name
          "policy_users"
        end

        policy do
          allow :create, :update, :destroy, if: ->(user) { user&.role == "admin" }
        end
      end
    end

    before do
      CommandPost::ResourceRegistry.register(policy_user_resource)
    end

    after do
      CommandPost::ResourceRegistry.reset!
      CommandPost::ResourceRegistry.register(UserResource)
      CommandPost::ResourceRegistry.register(LicenseResource)
    end

    context "when policy denies action based on user context" do
      before do
        CommandPost.configure do |config|
          config.current_user { OpenStruct.new(role: "member") }
        end
      end

      it "returns forbidden for new action when policy denies create" do
        get command_post.new_resource_path("policy_users"), as: :html
        expect(response).to have_http_status(:forbidden)
      end

      it "returns forbidden for create action when policy denies" do
        post command_post.resources_path("policy_users"),
             params: { record: { name: "Test", email: "test@example.com", role: "member" } },
             as: :html
        expect(response).to have_http_status(:forbidden)
      end

      it "returns forbidden for edit action when policy denies update" do
        user = create(:user)
        get command_post.edit_resource_path("policy_users", user), as: :html
        expect(response).to have_http_status(:forbidden)
      end

      it "returns forbidden for update action when policy denies" do
        user = create(:user)
        patch command_post.resource_path("policy_users", user),
              params: { record: { name: "Updated", email: user.email, role: user.role } },
              as: :html
        expect(response).to have_http_status(:forbidden)
      end

      it "returns forbidden for destroy action when policy denies" do
        user = create(:user)
        delete command_post.resource_path("policy_users", user), as: :html
        expect(response).to have_http_status(:forbidden)
      end
    end

    context "when policy allows action based on user context" do
      before do
        CommandPost.configure do |config|
          config.current_user { OpenStruct.new(role: "admin") }
        end
      end

      it "allows create action when policy permits" do
        get command_post.new_resource_path("policy_users"), as: :html
        expect(response).to have_http_status(:ok)
      end

      it "allows update action when policy permits" do
        user = create(:user)
        get command_post.edit_resource_path("policy_users", user), as: :html
        expect(response).to have_http_status(:ok)
      end

      it "allows destroy action when policy permits" do
        user = create(:user)
        delete command_post.resource_path("policy_users", user), as: :html
        expect(response).to redirect_to(command_post.resources_path("policy_users"))
      end
    end

    context "when no user is logged in" do
      before do
        CommandPost.configure do |config|
          config.current_user { nil }
        end
      end

      it "returns forbidden when policy requires user context" do
        get command_post.new_resource_path("policy_users"), as: :html
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe "custom action authorization" do
    # Create a resource with policy-controlled custom actions
    let(:policy_license_resource) do
      Class.new(CommandPost::Resource) do
        self.model_class_override = License

        def self.name
          "PolicyLicenseResource"
        end

        def self.resource_name
          "policy_licenses"
        end

        belongs_to :user, display: :email

        action :revoke, icon: "x-circle" do |license|
          license.update!(status: :revoked)
        end

        action :renew, icon: "refresh" do |license|
          license.update!(status: :active)
        end

        bulk_action :bulk_revoke do |licenses|
          licenses.update_all(status: :revoked)
        end

        bulk_action :bulk_export do |licenses|
          licenses.pluck(:license_key)
        end

        policy do
          allow :create, :update, :destroy, if: ->(user) { user&.role == "admin" }
          allow :revoke, if: ->(user) { user&.role == "admin" }
          allow :bulk_revoke, if: ->(user) { user&.role == "admin" }
          # renew and bulk_export are not allowed by policy
        end
      end
    end

    before do
      CommandPost::ResourceRegistry.register(policy_license_resource)
    end

    after do
      CommandPost::ResourceRegistry.reset!
      CommandPost::ResourceRegistry.register(UserResource)
      CommandPost::ResourceRegistry.register(LicenseResource)
    end

    context "when policy denies custom action" do
      let(:user) { create(:user) }
      let!(:license) { create(:license, user: user, status: "active") }

      before do
        CommandPost.configure do |config|
          config.current_user { OpenStruct.new(role: "member") }
        end
      end

      it "returns forbidden when policy denies the action" do
        post command_post.resource_action_path("policy_licenses", license, "revoke"), as: :html
        expect(response).to have_http_status(:forbidden)
      end

      it "returns forbidden for actions not in policy allow list" do
        post command_post.resource_action_path("policy_licenses", license, "renew"), as: :html
        expect(response).to have_http_status(:forbidden)
      end

      it "does not execute the action when forbidden" do
        post command_post.resource_action_path("policy_licenses", license, "revoke"), as: :html
        expect(license.reload.status).to eq("active")
      end
    end

    context "when policy allows custom action" do
      let(:user) { create(:user) }
      let!(:license) { create(:license, user: user, status: "active") }

      before do
        CommandPost.configure do |config|
          config.current_user { OpenStruct.new(role: "admin") }
        end
      end

      it "executes the action when policy allows" do
        post command_post.resource_action_path("policy_licenses", license, "revoke"), as: :html
        expect(response).to redirect_to(command_post.resource_path("policy_licenses", license))
        expect(license.reload.status).to eq("revoked")
      end

      it "returns forbidden for actions not in policy allow list even for admin" do
        post command_post.resource_action_path("policy_licenses", license, "renew"), as: :html
        expect(response).to have_http_status(:forbidden)
      end
    end

    context "when no policy is defined" do
      let(:user) { create(:user) }
      let!(:license) { create(:license, user: user, status: "active") }

      before do
        CommandPost.configure do |config|
          config.current_user { OpenStruct.new(role: "member") }
        end
      end

      it "allows custom actions by default" do
        # Using the regular LicenseResource which has no policy
        CommandPost::ResourceRegistry.register(LicenseResource)
        post command_post.resource_action_path("licenses", license, "revoke"), as: :html
        expect(response).to redirect_to(command_post.resource_path("licenses", license))
        expect(license.reload.status).to eq("revoked")
      end
    end
  end

  describe "bulk action authorization" do
    # Reuse the same policy_license_resource setup
    let(:policy_license_resource) do
      Class.new(CommandPost::Resource) do
        self.model_class_override = License

        def self.name
          "PolicyLicenseResource"
        end

        def self.resource_name
          "policy_licenses"
        end

        belongs_to :user, display: :email

        bulk_action :bulk_revoke do |licenses|
          licenses.update_all(status: :revoked)
        end

        bulk_action :bulk_export do |licenses|
          licenses.pluck(:license_key)
        end

        policy do
          allow :bulk_revoke, if: ->(user) { user&.role == "admin" }
          # bulk_export is not allowed by policy
        end
      end
    end

    before do
      CommandPost::ResourceRegistry.register(policy_license_resource)
    end

    after do
      CommandPost::ResourceRegistry.reset!
      CommandPost::ResourceRegistry.register(UserResource)
      CommandPost::ResourceRegistry.register(LicenseResource)
    end

    context "when policy denies bulk action" do
      let(:user) { create(:user) }
      let!(:licenses) { create_list(:license, 3, user: user, status: "active") }

      before do
        CommandPost.configure do |config|
          config.current_user { OpenStruct.new(role: "member") }
        end
      end

      it "returns forbidden when policy denies the bulk action" do
        post command_post.resource_bulk_action_path("policy_licenses", "bulk_revoke"),
             params: { ids: licenses.map(&:id) },
             as: :html
        expect(response).to have_http_status(:forbidden)
      end

      it "returns forbidden for bulk actions not in policy allow list" do
        post command_post.resource_bulk_action_path("policy_licenses", "bulk_export"),
             params: { ids: licenses.map(&:id) },
             as: :html
        expect(response).to have_http_status(:forbidden)
      end

      it "does not execute the bulk action when forbidden" do
        post command_post.resource_bulk_action_path("policy_licenses", "bulk_revoke"),
             params: { ids: licenses.map(&:id) },
             as: :html
        licenses.each do |license|
          expect(license.reload.status).to eq("active")
        end
      end
    end

    context "when policy allows bulk action" do
      let(:user) { create(:user) }
      let!(:licenses) { create_list(:license, 3, user: user, status: "active") }

      before do
        CommandPost.configure do |config|
          config.current_user { OpenStruct.new(role: "admin") }
        end
      end

      it "executes the bulk action when policy allows" do
        post command_post.resource_bulk_action_path("policy_licenses", "bulk_revoke"),
             params: { ids: licenses.map(&:id) },
             as: :html
        expect(response).to redirect_to(command_post.resources_path("policy_licenses"))
        licenses.each do |license|
          expect(license.reload.status).to eq("revoked")
        end
      end

      it "returns forbidden for bulk actions not in policy allow list even for admin" do
        post command_post.resource_bulk_action_path("policy_licenses", "bulk_export"),
             params: { ids: licenses.map(&:id) },
             as: :html
        expect(response).to have_http_status(:forbidden)
      end
    end

    context "when no policy is defined" do
      let(:user) { create(:user) }
      let!(:licenses) { create_list(:license, 3, user: user) }

      before do
        CommandPost.configure do |config|
          config.current_user { OpenStruct.new(role: "member") }
        end
      end

      it "allows bulk actions by default" do
        # Using the regular LicenseResource which has no policy
        CommandPost::ResourceRegistry.register(LicenseResource)
        post command_post.resource_bulk_action_path("licenses", "export"),
             params: { ids: licenses.map(&:id) },
             as: :html
        expect(response).to redirect_to(command_post.resources_path("licenses"))
      end
    end
  end

  describe "GET /autocomplete/:resource_name" do
    context "with valid query" do
      it "returns matching records as JSON" do
        create(:user, name: "Alice Smith", email: "alice@example.com")
        create(:user, name: "Bob Jones", email: "bob@example.com")
        create(:user, name: "Charlie Smith", email: "charlie@example.com")

        get command_post.autocomplete_path("users"), params: { q: "Smith" }, as: :json
        expect(response).to have_http_status(:ok)

        data = JSON.parse(response.body)
        expect(data.length).to eq(2)
        expect(data.map { |r| r["label"] }).to contain_exactly("Alice Smith", "Charlie Smith")
      end

      it "returns id and label for each record" do
        user = create(:user, name: "Test User")
        get command_post.autocomplete_path("users"), params: { q: "Test" }, as: :json

        data = JSON.parse(response.body)
        expect(data.first).to eq({ "id" => user.id, "label" => "Test User" })
      end

      it "limits results to 20 records" do
        create_list(:user, 25, name: "Test User")
        get command_post.autocomplete_path("users"), params: { q: "Test" }, as: :json

        data = JSON.parse(response.body)
        expect(data.length).to eq(20)
      end
    end

    context "with empty query" do
      it "returns empty array" do
        create(:user, name: "Test User")
        get command_post.autocomplete_path("users"), params: { q: "" }, as: :json

        data = JSON.parse(response.body)
        expect(data).to eq([])
      end

      it "returns empty array when query param is missing" do
        create(:user, name: "Test User")
        get command_post.autocomplete_path("users"), as: :json

        data = JSON.parse(response.body)
        expect(data).to eq([])
      end
    end

    context "with case-insensitive search" do
      it "matches regardless of case" do
        create(:user, name: "Alice SMITH")
        get command_post.autocomplete_path("users"), params: { q: "smith" }, as: :json

        data = JSON.parse(response.body)
        expect(data.length).to eq(1)
        expect(data.first["label"]).to eq("Alice SMITH")
      end
    end

    context "with custom display attribute" do
      let(:autocomplete_resource) do
        Class.new(CommandPost::Resource) do
          self.model_class_override = User

          def self.name
            "AutocompleteUserResource"
          end

          def self.resource_name
            "autocomplete_users"
          end

          def self.display_attribute
            :email
          end
        end
      end

      before do
        CommandPost::ResourceRegistry.register(autocomplete_resource)
      end

      after do
        CommandPost::ResourceRegistry.reset!
        CommandPost::ResourceRegistry.register(UserResource)
        CommandPost::ResourceRegistry.register(LicenseResource)
      end

      it "uses the display_attribute for searching and labeling" do
        create(:user, name: "Test User", email: "test@example.com")
        create(:user, name: "Another User", email: "another@example.com")

        get command_post.autocomplete_path("autocomplete_users"), params: { q: "test@" }, as: :json

        data = JSON.parse(response.body)
        expect(data.length).to eq(1)
        expect(data.first["label"]).to eq("test@example.com")
      end
    end

    context "with unknown resource" do
      it "returns not found" do
        get command_post.autocomplete_path("unknown_resources"), params: { q: "test" }, as: :json
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
