# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Bulk Actions Flow", type: :request do
  let(:bulk_resource) do
    Class.new(CommandPost::Resource) do
      def self.name
        "BulkUserResource"
      end

      def self.model
        User
      end

      def self.resource_name
        "bulk_users"
      end

      bulk_action :deactivate do |records|
        records.update_all(active: false)
      end

      bulk_action :archive do |records|
        records.update_all(role: "archived")
      end

      bulk_action :failing_action do |_records|
        false # Returns false to trigger rollback
      end
    end
  end
  let!(:alice) { create(:user, active: true, role: "user") }
  let!(:bob) { create(:user, active: true, role: "user") }
  let!(:charlie) { create(:user, active: true, role: "admin") }

  before do
    CommandPost::ResourceRegistry.register(bulk_resource)
  end

  describe "executing bulk actions" do
    it "applies action to selected records" do
      post command_post.resource_bulk_action_path("bulk_users", "deactivate"),
           params: { ids: [alice.id, bob.id] }

      expect(response).to redirect_to(command_post.resources_path("bulk_users"))

      alice.reload
      bob.reload
      charlie.reload

      expect(alice.active).to be false
      expect(bob.active).to be false
      expect(charlie.active).to be true # Not selected
    end

    it "handles empty selection" do
      post command_post.resource_bulk_action_path("bulk_users", "deactivate"),
           params: { ids: [] }

      expect(response).to redirect_to(command_post.resources_path("bulk_users"))
      expect(flash[:alert]).to include("No records selected")
    end

    it "returns not_found for unknown action" do
      post command_post.resource_bulk_action_path("bulk_users", "nonexistent"),
           params: { ids: [alice.id] }

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "bulk action with rollback" do
    it "rolls back transaction when action returns false" do
      original_role = alice.role

      post command_post.resource_bulk_action_path("bulk_users", "failing_action"),
           params: { ids: [alice.id, bob.id] }

      alice.reload
      expect(alice.role).to eq(original_role)
    end
  end

  describe "bulk action with invalid IDs" do
    it "ignores non-existent IDs" do
      post command_post.resource_bulk_action_path("bulk_users", "deactivate"),
           params: { ids: [alice.id, 99_999] }

      # Should redirect with alert about inaccessible records
      expect(response).to redirect_to(command_post.resources_path("bulk_users"))
    end

    it "filters out zero and empty IDs but rejects if non-existent IDs remain" do
      # IDs [alice.id, 0, -1, ""] become [alice.id, -1] after filtering
      # Since -1 doesn't exist, security check fails
      post command_post.resource_bulk_action_path("bulk_users", "deactivate"),
           params: { ids: [alice.id, 0, -1, ""] }

      expect(response).to redirect_to(command_post.resources_path("bulk_users"))
      expect(flash[:alert]).to include("not accessible")

      alice.reload
      expect(alice.active).to be true # Action did not execute due to security check
    end
  end

  describe "bulk action with tenant scoping" do
    before do
      CommandPost.configure do |config|
        config.tenant_scope do |scope|
          scope.where(role: "user") # Only users, not admins
        end
      end
    end

    it "only affects records within tenant scope" do
      # charlie is admin, outside tenant scope
      post command_post.resource_bulk_action_path("bulk_users", "deactivate"),
           params: { ids: [alice.id, bob.id, charlie.id] }

      # Should fail because charlie is not accessible
      expect(response).to redirect_to(command_post.resources_path("bulk_users"))
      expect(flash[:alert]).to include("not accessible")
    end
  end
end
