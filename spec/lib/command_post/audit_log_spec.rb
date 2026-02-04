# frozen_string_literal: true

require "rails_helper"
require "ostruct"

RSpec.describe CommandPost::AuditLog do
  before do
    CommandPost::AuditLog.clear!
    CommandPost.reset_configuration!
  end

  describe CommandPost::AuditLog::Entry do
    describe "#initialize" do
      it "sets attributes from hash" do
        entry = described_class.new(
          user: "admin",
          action: :create,
          resource: "User",
          record_id: 1,
          changes: { name: %w[old new] },
          ip_address: "127.0.0.1"
        )

        expect(entry.user).to eq("admin")
        expect(entry.action).to eq(:create)
        expect(entry.resource).to eq("User")
        expect(entry.record_id).to eq(1)
        expect(entry.changes).to eq({ name: %w[old new] })
        expect(entry.ip_address).to eq("127.0.0.1")
      end

      it "sets timestamp to current time when not provided" do
        before_time = Time.current
        entry = described_class.new(action: :create)
        after_time = Time.current

        expect(entry.timestamp).to be >= before_time
        expect(entry.timestamp).to be <= after_time
      end

      it "uses provided timestamp when given" do
        custom_time = 1.hour.ago
        entry = described_class.new(timestamp: custom_time)
        expect(entry.timestamp).to eq(custom_time)
      end
    end

    describe "#to_h" do
      it "returns hash representation" do
        timestamp = Time.current
        entry = described_class.new(
          user: "admin",
          action: :create,
          resource: "User",
          record_id: 1,
          changes: { name: %w[old new] },
          ip_address: "127.0.0.1",
          timestamp: timestamp
        )

        expect(entry.to_h).to eq({
                                   user: "admin",
                                   action: :create,
                                   resource: "User",
                                   record_id: 1,
                                   changes: { name: %w[old new] },
                                   ip_address: "127.0.0.1",
                                   timestamp: timestamp,
                                 })
      end
    end
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
        changes: {},
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
                            record_id: 1, changes: {}, ip_address: "127.0.0.1"
                          ))
      described_class.log(OpenStruct.new(
                            user: "admin", action: :update, resource: "User",
                            record_id: 1, changes: { name: %w[old new] }, ip_address: "127.0.0.1"
                          ))
      described_class.log(OpenStruct.new(
                            user: "admin", action: :destroy, resource: "Post",
                            record_id: 5, changes: {}, ip_address: "192.168.1.1"
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
                            record_id: 1, changes: {}, ip_address: "127.0.0.1"
                          ))
    end

    it "removes all entries" do
      expect(described_class.entries).not_to be_empty

      described_class.clear!

      expect(described_class.entries).to be_empty
    end
  end
end
