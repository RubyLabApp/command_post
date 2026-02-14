require "rails_helper"

RSpec.describe IronAdmin::Configuration::Theme::Styles do
  describe "#initialize" do
    it "creates accessors for string attributes" do
      styles = described_class.new(base: "inline-flex", size: "px-4")

      expect(styles.base).to eq("inline-flex")
      expect(styles.size).to eq("px-4")
    end

    it "creates accessors for hash attributes" do
      styles = described_class.new(variants: { primary: "bg-blue" })

      expect(styles.variants).to eq(primary: "bg-blue")
    end

    it "duplicates hash values to prevent shared state" do
      original = { primary: "bg-blue" }
      styles = described_class.new(variants: original)
      styles.variants[:secondary] = "bg-white"

      expect(original).not_to have_key(:secondary)
    end

    it "creates accessors for array attributes" do
      styles = described_class.new(colors: %w[red blue])

      expect(styles.colors).to eq(%w[red blue])
    end
  end

  describe "#[]" do
    subject(:styles) { described_class.new(base: "inline-flex", variants: { primary: "bg-blue" }) }

    it "reads string values" do
      expect(styles[:base]).to eq("inline-flex")
    end

    it "reads hash values" do
      expect(styles[:variants]).to eq(primary: "bg-blue")
    end

    it "returns nil for unknown keys" do
      expect(styles[:nonexistent]).to be_nil
    end
  end

  describe "#[]=" do
    subject(:styles) { described_class.new(base: "inline-flex") }

    it "updates existing keys" do
      styles[:base] = "block"

      expect(styles.base).to eq("block")
    end

    it "creates new keys dynamically" do
      styles[:new_key] = "new-value"

      expect(styles.new_key).to eq("new-value")
    end
  end

  describe "setter methods" do
    it "allows updating string values" do
      styles = described_class.new(base: "inline-flex")
      styles.base = "block"

      expect(styles.base).to eq("block")
    end

    it "allows updating hash values" do
      styles = described_class.new(variants: { primary: "bg-blue" })
      styles.variants = { primary: "bg-red" }

      expect(styles.variants[:primary]).to eq("bg-red")
    end
  end
end
