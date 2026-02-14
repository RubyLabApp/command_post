# frozen_string_literal: true

require "rails_helper"
require "ostruct"

RSpec.describe IronAdmin::FieldTypeRegistry do
  before { described_class.reset! }

  describe ".register" do
    it "registers a field type by name" do
      described_class.register(:star_rating) do
        display { |record, field| record.public_send(field.name).to_s }
      end

      expect(described_class.registered?(:star_rating)).to be true
    end

    it "raises on duplicate registration" do
      described_class.register(:star_rating) do
        display { |record, field| record.public_send(field.name).to_s }
      end

      expect do
        described_class.register(:star_rating) do
          display { |_record, _field| "dup" }
        end
      end.to raise_error(ArgumentError, /already registered/)
    end
  end

  describe ".find" do
    it "returns the config for a registered type" do
      described_class.register(:star_rating) do
        display { |_record, _field| "stars" }
      end

      config = described_class.find(:star_rating)
      expect(config).to be_a(IronAdmin::FieldTypeConfig)
    end

    it "returns nil for unregistered type" do
      expect(described_class.find(:unknown)).to be_nil
    end
  end

  describe ".reset!" do
    it "clears all registrations" do
      described_class.register(:star_rating) do
        display { |_record, _field| "stars" }
      end

      described_class.reset!
      expect(described_class.registered?(:star_rating)).to be false
    end
  end
end

RSpec.describe IronAdmin::FieldTypeConfig do
  describe "#render_display" do
    it "calls the display block" do
      config = described_class.new
      config.display { |record, field| "value: #{record.public_send(field.name)}" }

      record = OpenStruct.new(rating: 4)
      field = IronAdmin::Field.new(:rating, type: :star_rating)

      expect(config.render_display(record, field)).to eq("value: 4")
    end
  end

  describe "#render_index_display" do
    context "when index_display is defined" do
      it "uses the index_display block" do
        config = described_class.new
        config.display { |record, field| "full: #{record.public_send(field.name)}" }
        config.index_display { |_record, _field| "short" }

        record = OpenStruct.new(rating: 4)
        field = IronAdmin::Field.new(:rating, type: :star_rating)

        expect(config.render_index_display(record, field)).to eq("short")
      end
    end

    context "when index_display is not defined" do
      it "falls back to display block" do
        config = described_class.new
        config.display { |_record, _field| "full" }

        record = OpenStruct.new(rating: 4)
        field = IronAdmin::Field.new(:rating, type: :star_rating)

        expect(config.render_index_display(record, field)).to eq("full")
      end
    end
  end

  describe "#form_component" do
    it "stores a form component class" do
      klass = Class.new
      config = described_class.new
      config.form_component(klass)

      expect(config.form_component_class).to eq(klass)
    end
  end

  describe "#form_partial" do
    it "stores a form partial path" do
      config = described_class.new
      config.form_partial("fields/star_rating")

      expect(config.form_partial_path).to eq("fields/star_rating")
    end
  end
end
