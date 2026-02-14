# frozen_string_literal: true

require "rails_helper"

RSpec.describe IronAdmin::AuditEntry do
  describe ".table_exists?" do
    it "returns true when table exists" do
      expect(described_class.table_exists?).to be true
    end

    it "returns false gracefully when database error occurs" do
      allow(described_class.superclass).to receive(:table_exists?).and_raise(ActiveRecord::StatementInvalid)
      expect(described_class.table_exists?).to be false
    end
  end
end
