# frozen_string_literal: true

require "rails_helper"
require "rails/generators"
require "generators/iron_admin/install_audit/install_audit_generator"

RSpec.describe IronAdmin::Generators::InstallAuditGenerator, type: :generator do
  describe "generator class" do
    it "is defined" do
      expect(described_class).to be_a(Class)
    end

    it "inherits from Rails::Generators::Base" do
      expect(described_class.superclass).to eq(Rails::Generators::Base)
    end

    it "includes Rails::Generators::Migration" do
      expect(described_class.included_modules).to include(Rails::Generators::Migration)
    end

    it "has a source_root" do
      expect(described_class.source_root).to be_a(String)
      expect(File.directory?(described_class.source_root)).to be true
    end

    it "has a next_migration_number class method" do
      expect(described_class).to respond_to(:next_migration_number)
    end

    it "generates timestamp-based migration numbers" do
      number = described_class.next_migration_number("db/migrate")
      expect(number).to match(/^\d{14}$/)
    end
  end

  describe "migration template" do
    let(:template_path) do
      File.join(described_class.source_root, "create_iron_admin_audit_entries.rb.tt")
    end

    it "exists" do
      expect(File.exist?(template_path)).to be true
    end

    it "creates iron_admin_audit_entries table" do
      content = File.read(template_path)
      expect(content).to include("create_table :iron_admin_audit_entries")
    end

    it "includes required columns" do
      content = File.read(template_path)
      expect(content).to include("t.string :action")
      expect(content).to include("t.string :resource")
      expect(content).to include("t.integer :record_id")
      expect(content).to include("t.string :user_identifier")
      expect(content).to include("t.string :ip_address")
      expect(content).to include("t.text :record_changes")
    end

    it "includes timestamps" do
      content = File.read(template_path)
      expect(content).to include("t.timestamps")
    end

    it "includes indexes" do
      content = File.read(template_path)
      expect(content).to include("add_index :iron_admin_audit_entries, :resource")
      expect(content).to include("add_index :iron_admin_audit_entries, :action")
      expect(content).to include("add_index :iron_admin_audit_entries, :created_at")
    end
  end
end
