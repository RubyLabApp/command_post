require "rails_helper"

RSpec.describe CommandPost::Field do
  describe "#initialize" do
    it "stores name and options" do
      field = described_class.new(:email, type: :text, readonly: true)

      expect(field.name).to eq(:email)
      expect(field.type).to eq(:text)
      expect(field.readonly).to eq(true)
    end

    it "defaults visible to true" do
      field = described_class.new(:name)
      expect(field.visible).to eq(true)
    end

    it "defaults readonly to false" do
      field = described_class.new(:name)
      expect(field.readonly).to eq(false)
    end
  end

  describe "#visible?" do
    it "returns true when visible" do
      field = described_class.new(:name, visible: true)
      expect(field.visible?(nil)).to eq(true)
    end

    it "evaluates proc with user" do
      field = described_class.new(:name, visible: ->(user) { user == :admin })
      expect(field.visible?(:admin)).to eq(true)
      expect(field.visible?(:user)).to eq(false)
    end
  end

  describe "#readonly?" do
    it "evaluates proc with user" do
      field = described_class.new(:name, readonly: ->(user) { user != :admin })
      expect(field.readonly?(:admin)).to eq(false)
      expect(field.readonly?(:user)).to eq(true)
    end
  end
end
