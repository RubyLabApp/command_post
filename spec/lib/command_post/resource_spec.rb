require "rails_helper"
require_relative "../../support/test_resources"

RSpec.describe CommandPost::Resource do
  describe "model inference" do
    it "infers model from class name" do
      expect(TestUserResource.model).to eq(User)
    end

    it "infers model for TestLicenseResource" do
      expect(TestLicenseResource.model).to eq(License)
    end
  end

  describe "field overrides" do
    it "merges overrides with inferred fields" do
      fields = TestLicenseResource.resolved_fields
      license_key = fields.find { |f| f.name == :license_key }

      expect(license_key.readonly).to eq(true)
    end

    it "uses inferred fields when no override" do
      fields = TestUserResource.resolved_fields
      expect(fields).not_to be_empty
    end
  end

  describe "searchable" do
    it "uses custom searchable columns" do
      expect(TestLicenseResource.searchable_columns).to eq([ :license_key ])
    end

    it "defaults to string/text columns" do
      columns = TestUserResource.searchable_columns
      expect(columns).to include(:email)
      expect(columns).to include(:name)
    end
  end

  describe "filters" do
    it "stores custom filters" do
      filters = TestLicenseResource.defined_filters
      expect(filters.length).to eq(2)
      expect(filters.first[:name]).to eq(:status)
    end
  end

  describe "scopes" do
    it "stores named scopes" do
      scopes = TestLicenseResource.defined_scopes
      expect(scopes.length).to eq(2)
      expect(scopes.first[:name]).to eq(:active)
      expect(scopes.first[:default]).to eq(true)
    end
  end

  describe "actions" do
    it "stores custom actions" do
      actions = TestLicenseResource.defined_actions
      expect(actions.length).to eq(1)
      expect(actions.first[:name]).to eq(:revoke)
      expect(actions.first[:confirm]).to eq(true)
    end
  end

  describe "bulk actions" do
    it "stores bulk actions" do
      expect(TestLicenseResource.defined_bulk_actions.length).to eq(1)
      expect(TestLicenseResource.defined_bulk_actions.first[:name]).to eq(:export)
    end
  end

  describe "view field lists" do
    it "stores index fields" do
      expect(TestLicenseResource.index_field_names).to eq([ :license_key, :status, :expires_at ])
    end

    it "stores form fields" do
      expect(TestLicenseResource.form_field_names).to eq([ :license_type, :status, :max_devices ])
    end

    it "defaults to all fields" do
      expect(TestUserResource.index_field_names).to be_nil
    end
  end

  describe "associations" do
    it "stores belongs_to declarations" do
      assoc = TestLicenseResource.defined_associations[:user]
      expect(assoc[:kind]).to eq(:belongs_to)
      expect(assoc[:display]).to eq(:email)
    end

    it "stores has_many declarations" do
      assoc = TestUserResource.defined_associations[:licenses]
      expect(assoc[:kind]).to eq(:has_many)
    end

    it "resolves has_many associations with resource and reflection" do
      CommandPost::ResourceRegistry.reset!
      CommandPost::ResourceRegistry.register(TestUserResource)
      CommandPost::ResourceRegistry.register(TestLicenseResource)

      associations = TestUserResource.has_many_associations
      licenses_assoc = associations.find { |a| a[:name] == :licenses }
      expect(licenses_assoc).to be_present
      expect(licenses_assoc[:resource]).to eq(TestLicenseResource)
    end

    it "infers belongs_to fields from model" do
      fields = TestLicenseResource.resolved_fields
      user_field = fields.find { |f| f.name == :user }
      expect(user_field).to be_present
      expect(user_field.type).to eq(:belongs_to)
      expect(user_field.options[:foreign_key]).to eq(:user_id)
      expect(user_field.options[:association_class]).to eq(User)
    end

    it "applies display override from DSL to inferred field" do
      fields = TestLicenseResource.resolved_fields
      user_field = fields.find { |f| f.name == :user }
      expect(user_field.options[:display]).to eq(:email)
    end

    it "excludes raw foreign key columns for belongs_to associations" do
      fields = TestLicenseResource.resolved_fields
      expect(fields.map(&:name)).not_to include(:user_id)
    end
  end

  describe "menu" do
    it "stores menu options" do
      expect(TestLicenseResource.menu_options).to eq({ priority: 1, icon: "key", group: "Licensing" })
    end

    it "defaults to empty hash" do
      expect(TestUserResource.menu_options).to eq({})
    end
  end
end
