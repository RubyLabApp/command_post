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
      it "redirects with error" do
        post command_post.resource_action_path("licenses", license, "nonexistent"), as: :html
        expect(response).to redirect_to(command_post.resource_path("licenses", license))
        expect(flash[:alert]).to eq("Action not found.")
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
      it "redirects with error" do
        post command_post.resource_bulk_action_path("licenses", "nonexistent"),
             params: { ids: licenses.map(&:id) },
             as: :html
        expect(response).to redirect_to(command_post.resources_path("licenses"))
        expect(flash[:alert]).to eq("Action not found.")
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
end
