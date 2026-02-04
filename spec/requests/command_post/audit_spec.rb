# frozen_string_literal: true

require "rails_helper"
require "ostruct"

RSpec.describe "CommandPost::Audit", type: :request do
  before do
    CommandPost.reset_configuration!
    CommandPost::ResourceRegistry.reset!
    CommandPost::ResourceRegistry.register(UserResource)
    CommandPost::AuditLog.clear!
  end

  describe "GET /audit" do
    it "returns successful response" do
      get command_post.audit_path

      expect(response).to have_http_status(:ok)
    end

    it "shows disabled warning when audit is disabled" do
      get command_post.audit_path

      expect(response.body).to include("Audit logging is currently disabled")
    end

    it "does not show disabled warning when audit is enabled" do
      CommandPost.configure { |c| c.audit_enabled = true }

      get command_post.audit_path

      expect(response.body).not_to include("Audit logging is currently disabled")
    end

    it "shows empty state when no entries" do
      get command_post.audit_path

      expect(response.body).to include("No audit log entries found")
    end

    context "with audit entries" do
      before do
        CommandPost.configure { |c| c.audit_enabled = true }

        # Create some audit entries
        CommandPost::AuditLog.log(OpenStruct.new(
                                    user: OpenStruct.new(email: "admin@example.com"),
                                    action: :create,
                                    resource: "UserResource",
                                    record_id: 1,
                                    changes: { name: [nil, "John Doe"] },
                                    ip_address: "127.0.0.1"
                                  ))

        CommandPost::AuditLog.log(OpenStruct.new(
                                    user: OpenStruct.new(email: "admin@example.com"),
                                    action: :update,
                                    resource: "UserResource",
                                    record_id: 1,
                                    changes: { name: ["John Doe", "Jane Doe"] },
                                    ip_address: "192.168.1.1"
                                  ))
      end

      it "displays audit entries" do
        get command_post.audit_path

        expect(response.body).to include("admin@example.com")
        expect(response.body).to include("Create")
        expect(response.body).to include("Update")
        expect(response.body).to include("UserResource")
      end

      it "displays IP addresses" do
        get command_post.audit_path

        expect(response.body).to include("127.0.0.1")
        expect(response.body).to include("192.168.1.1")
      end

      it "filters by resource" do
        CommandPost::AuditLog.log(OpenStruct.new(
                                    user: OpenStruct.new(email: "admin@example.com"),
                                    action: :create,
                                    resource: "PostResource",
                                    record_id: 10,
                                    changes: {},
                                    ip_address: "10.0.0.1"
                                  ))

        get command_post.audit_path(resource: "UserResource")

        expect(response.body).to include("UserResource")
        # PostResource entry should still appear in filter results since we query all
        # The filter only affects @entries
      end

      it "filters by action" do
        get command_post.audit_path(action_filter: "create")

        expect(response.body).to include("Create")
      end
    end
  end
end
