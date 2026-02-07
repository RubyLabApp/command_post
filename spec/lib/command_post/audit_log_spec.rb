# frozen_string_literal: true

require "rails_helper"
require "ostruct"

RSpec.describe CommandPost::AuditLog do
  before do
    described_class.clear!
    CommandPost.reset_configuration!
  end

  describe ".entries" do
    it "returns an empty array by default" do
      expect(described_class.entries).to eq([])
    end

    it "returns accumulated entries" do
      CommandPost.configure { |c| c.audit_enabled = true }

      event = OpenStruct.new(
        user: "admin",
        action: :create,
        resource: "User",
        record_id: 1,
        record_changes: {},
        ip_address: "127.0.0.1"
      )
      described_class.log(event)

      expect(described_class.entries.length).to eq(1)
    end
  end

  describe ".log" do
    let(:event) do
      OpenStruct.new(
        user: "admin",
        action: :create,
        resource: "User",
        record_id: 1,
        changes: { name: [nil, "John"] },
        ip_address: "127.0.0.1"
      )
    end

    context "when audit_enabled is true" do
      before do
        CommandPost.configure { |c| c.audit_enabled = true }
      end

      it "creates an entry" do
        entry = described_class.log(event)

        expect(entry).to be_a(CommandPost::AuditLog::Entry)
        expect(entry.user).to eq("admin")
        expect(entry.action).to eq(:create)
        expect(entry.resource).to eq("User")
        expect(entry.record_id).to eq(1)
        expect(entry.changes).to eq({ name: [nil, "John"] })
        expect(entry.ip_address).to eq("127.0.0.1")
      end

      it "adds entry to entries list" do
        described_class.log(event)

        expect(described_class.entries.length).to eq(1)
      end

      it "accumulates multiple entries" do
        3.times { described_class.log(event) }

        expect(described_class.entries.length).to eq(3)
      end
    end

    context "when audit_enabled is false" do
      before do
        CommandPost.configure { |c| c.audit_enabled = false }
      end

      it "does not create an entry" do
        result = described_class.log(event)

        expect(result).to be_nil
        expect(described_class.entries).to be_empty
      end
    end

    context "when audit_enabled is not set (default)" do
      it "does not create an entry" do
        result = described_class.log(event)

        expect(result).to be_nil
        expect(described_class.entries).to be_empty
      end
    end
  end

  describe ".query" do
    before do
      CommandPost.configure { |c| c.audit_enabled = true }

      # Create test entries
      described_class.log(OpenStruct.new(
                            user: "admin", action: :create, resource: "User",
                            record_id: 1, record_changes: {}, ip_address: "127.0.0.1"
                          ))
      described_class.log(OpenStruct.new(
                            user: "admin", action: :update, resource: "User",
                            record_id: 1, changes: { name: %w[old new] }, ip_address: "127.0.0.1"
                          ))
      described_class.log(OpenStruct.new(
                            user: "admin", action: :destroy, resource: "Post",
                            record_id: 5, record_changes: {}, ip_address: "192.168.1.1"
                          ))
    end

    it "returns all entries when no filters" do
      result = described_class.query

      expect(result.length).to eq(3)
    end

    it "filters by resource" do
      result = described_class.query(resource: "User")

      expect(result.length).to eq(2)
      expect(result.all? { |e| e.resource == "User" }).to be true
    end

    it "filters by action" do
      result = described_class.query(action: :create)

      expect(result.length).to eq(1)
      expect(result.first.action).to eq(:create)
    end

    it "filters by record_id" do
      result = described_class.query(record_id: 5)

      expect(result.length).to eq(1)
      expect(result.first.record_id).to eq(5)
    end

    it "filters by from date" do
      # Manipulate timestamps for testing
      described_class.entries[0].timestamp = 2.days.ago
      described_class.entries[1].timestamp = 1.day.ago
      described_class.entries[2].timestamp = Time.current

      result = described_class.query(from: 1.day.ago.beginning_of_day)

      expect(result.length).to eq(2)
    end

    it "filters by to date" do
      # Manipulate timestamps for testing
      described_class.entries[0].timestamp = 2.days.ago
      described_class.entries[1].timestamp = 1.day.ago
      described_class.entries[2].timestamp = Time.current

      result = described_class.query(to: 1.day.ago.end_of_day)

      expect(result.length).to eq(2)
    end

    it "combines multiple filters" do
      result = described_class.query(resource: "User", action: :update)

      expect(result.length).to eq(1)
      expect(result.first.action).to eq(:update)
      expect(result.first.resource).to eq("User")
    end
  end

  describe ".clear!" do
    before do
      CommandPost.configure { |c| c.audit_enabled = true }
      described_class.log(OpenStruct.new(
                            user: "admin", action: :create, resource: "User",
                            record_id: 1, record_changes: {}, ip_address: "127.0.0.1"
                          ))
    end

    it "removes all entries" do
      expect(described_class.entries).not_to be_empty

      described_class.clear!

      expect(described_class.entries).to be_empty
    end
  end

  describe "database storage backend" do
    before do
      CommandPost.configure do |c|
        c.audit_enabled = true
        c.audit_storage = :database
      end
      CommandPost::AuditEntry.delete_all
    end

    after do
      CommandPost::AuditEntry.delete_all
    end

    describe ".log" do
      let(:event) do
        OpenStruct.new(
          user: "admin",
          action: :create,
          resource: "User",
          record_id: 1,
          changes: { name: [nil, "John"] },
          ip_address: "127.0.0.1"
        )
      end

      it "creates a database record" do
        expect { described_class.log(event) }.to change(CommandPost::AuditEntry, :count).by(1)
      end

      it "stores the correct attributes" do
        described_class.log(event)
        entry = CommandPost::AuditEntry.last

        expect(entry.user_identifier).to eq("admin")
        expect(entry.action).to eq("create")
        expect(entry.resource).to eq("User")
        expect(entry.record_id).to eq(1)
        expect(entry.record_changes).to eq({ "name" => [nil, "John"] })
        expect(entry.ip_address).to eq("127.0.0.1")
      end

      it "extracts user id when user responds to id" do
        user = OpenStruct.new(id: 42, email: "admin@example.com")
        event_with_user = OpenStruct.new(
          user: user,
          action: :update,
          resource: "Post",
          record_id: 10,
          record_changes: {},
          ip_address: "10.0.0.1"
        )

        described_class.log(event_with_user)
        entry = CommandPost::AuditEntry.last

        expect(entry.user_identifier).to eq("42")
      end

      it "accumulates multiple entries in database" do
        3.times { described_class.log(event) }

        expect(CommandPost::AuditEntry.count).to eq(3)
      end
    end

    describe ".query" do
      before do
        # Create test entries with specific timestamps
        CommandPost::AuditEntry.create!(
          user_identifier: "admin",
          action: "create",
          resource: "User",
          record_id: 1,
          record_changes: {},
          ip_address: "127.0.0.1",
          created_at: 2.days.ago
        )
        CommandPost::AuditEntry.create!(
          user_identifier: "admin",
          action: "update",
          resource: "User",
          record_id: 1,
          record_changes: { name: %w[old new] },
          ip_address: "127.0.0.1",
          created_at: 1.day.ago
        )
        CommandPost::AuditEntry.create!(
          user_identifier: "admin",
          action: "destroy",
          resource: "Post",
          record_id: 5,
          record_changes: {},
          ip_address: "192.168.1.1",
          created_at: Time.current
        )
      end

      it "returns all entries when no filters" do
        result = described_class.query

        expect(result.length).to eq(3)
      end

      it "returns entries ordered by created_at desc" do
        result = described_class.query

        expect(result.first.action).to eq("destroy")
        expect(result.last.action).to eq("create")
      end

      it "filters by resource" do
        result = described_class.query(resource: "User")

        expect(result.length).to eq(2)
        expect(result.all? { |e| e.resource == "User" }).to be true
      end

      it "filters by action" do
        result = described_class.query(action: "create")

        expect(result.length).to eq(1)
        expect(result.first.action).to eq("create")
      end

      it "filters by record_id" do
        result = described_class.query(record_id: 5)

        expect(result.length).to eq(1)
        expect(result.first.record_id).to eq(5)
      end

      it "filters by from date" do
        result = described_class.query(from: 1.day.ago.beginning_of_day)

        expect(result.length).to eq(2)
      end

      it "filters by to date" do
        result = described_class.query(to: 1.day.ago.end_of_day)

        expect(result.length).to eq(2)
      end

      it "combines multiple filters" do
        result = described_class.query(resource: "User", action: "update")

        expect(result.length).to eq(1)
        expect(result.first.action).to eq("update")
        expect(result.first.resource).to eq("User")
      end
    end

    describe ".clear!" do
      before do
        CommandPost::AuditEntry.create!(
          user_identifier: "admin",
          action: "create",
          resource: "User",
          record_id: 1,
          record_changes: {},
          ip_address: "127.0.0.1"
        )
      end

      it "removes all database entries" do
        expect(CommandPost::AuditEntry.count).to eq(1)

        described_class.clear!

        expect(CommandPost::AuditEntry.count).to eq(0)
      end
    end
  end

  describe "audit_storage configuration" do
    it "defaults to :memory" do
      CommandPost.reset_configuration!
      expect(CommandPost.configuration.audit_storage).to eq(:memory)
    end

    it "can be set to :database" do
      CommandPost.configure { |c| c.audit_storage = :database }
      expect(CommandPost.configuration.audit_storage).to eq(:database)
    end
  end

  describe ".database_storage_available?" do
    it "returns false when audit_storage is :memory" do
      CommandPost.configure { |c| c.audit_storage = :memory }
      expect(described_class.database_storage_available?).to be false
    end

    it "returns true when audit_storage is :database and table exists" do
      CommandPost.configure { |c| c.audit_storage = :database }
      expect(described_class.database_storage_available?).to be true
    end

    it "returns false when table does not exist" do
      CommandPost.configure { |c| c.audit_storage = :database }
      allow(CommandPost::AuditEntry).to receive(:table_exists?).and_return(false)
      expect(described_class.database_storage_available?).to be false
    end
  end

  describe "graceful fallback to memory" do
    let(:event) do
      OpenStruct.new(
        user: "admin",
        action: :create,
        resource: "User",
        record_id: 1,
        changes: {},
        ip_address: "127.0.0.1"
      )
    end

    it "falls back to memory storage when database table does not exist" do
      CommandPost.configure do |c|
        c.audit_enabled = true
        c.audit_storage = :database
      end
      allow(CommandPost::AuditEntry).to receive(:table_exists?).and_return(false)

      expect { described_class.log(event) }.not_to raise_error
      expect(described_class.entries.length).to eq(1)
    end
  end
end
