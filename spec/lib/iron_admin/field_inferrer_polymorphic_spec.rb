# frozen_string_literal: true

require "rails_helper"

RSpec.describe IronAdmin::FieldInferrer do
  before do
    IronAdmin::ResourceRegistry.register(UserResource)
    IronAdmin::ResourceRegistry.register(LicenseResource)
    IronAdmin::ResourceRegistry.register(NoteResource)
  end

  describe "polymorphic detection" do
    it "detects polymorphic belongs_to association" do
      fields = described_class.call(Note)
      notable_field = fields.find { |f| f.name == :notable }

      expect(notable_field).to be_present
      expect(notable_field.type).to eq(:polymorphic_belongs_to)
    end

    it "stores type_column and id_column in options" do
      fields = described_class.call(Note)
      notable_field = fields.find { |f| f.name == :notable }

      expect(notable_field.options[:type_column]).to eq(:notable_type)
      expect(notable_field.options[:id_column]).to eq(:notable_id)
    end

    it "does not create separate fields for type and id columns" do
      fields = described_class.call(Note)
      field_names = fields.map(&:name)

      expect(field_names).not_to include(:notable_type)
      expect(field_names).not_to include(:notable_id)
    end
  end

  describe "Resource DSL" do
    it "stores polymorphic: true in association config" do
      config = NoteResource.defined_associations[:notable]
      expect(config[:polymorphic]).to be true
    end

    it "stores types list" do
      config = NoteResource.defined_associations[:notable]
      expect(config[:types]).to eq([User, License])
    end
  end

  describe "resolved_fields" do
    it "includes polymorphic field with types from DSL" do
      fields = NoteResource.resolved_fields
      notable_field = fields.find { |f| f.name == :notable }

      expect(notable_field.type).to eq(:polymorphic_belongs_to)
      expect(notable_field.options[:types]).to eq([User, License])
    end
  end
end
