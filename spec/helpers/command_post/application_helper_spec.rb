require "rails_helper"

RSpec.describe CommandPost::ApplicationHelper, type: :helper do
  before do
    CommandPost::ResourceRegistry.register(UserResource)
    CommandPost::ResourceRegistry.register(LicenseResource)
  end

  describe "#display_field_value" do
    let(:user) { create(:user, name: "John Doe", email: "john@example.com") }

    context "with regular field" do
      let(:field) { CommandPost::Field.new(:name, type: :text) }

      it "returns field value" do
        expect(helper.display_field_value(user, field)).to eq("John Doe")
      end
    end

    context "with belongs_to field" do
      let(:license) { create(:license, user: user) }
      let(:field) { CommandPost::Field.new(:user, type: :belongs_to, display: :email) }

      it "displays associated record" do
        result = helper.display_field_value(license, field)

        expect(result).to include("john@example.com")
      end
    end

    context "with badge field" do
      let(:license) { create(:license, user: user, status: :active) }
      let(:field) { CommandPost::Field.new(:status, type: :badge, colors: { active: :green }) }

      it "returns badge html" do
        result = helper.display_field_value(license, field)

        expect(result).to include("Active")
        expect(result).to include("rounded-full")
      end
    end
  end

  describe "#display_record_label" do
    let(:user) { create(:user, name: "John Doe", email: "john@example.com") }

    context "with proc display method" do
      it "calls the proc with record" do
        display = ->(r) { "Custom: #{r.name}" }

        expect(helper.display_record_label(user, display)).to eq("Custom: John Doe")
      end
    end

    context "with symbol display method" do
      it "calls the method on record" do
        expect(helper.display_record_label(user, :email)).to eq("john@example.com")
      end
    end

    context "with string display method" do
      it "calls the method on record" do
        expect(helper.display_record_label(user, "name")).to eq("John Doe")
      end
    end

    context "without display method" do
      it "finds first available display method" do
        expect(helper.display_record_label(user)).to eq("John Doe")
      end
    end

    context "when no display method found" do
      let(:minimal_record) do
        double("Record", id: 123, class: double(model_name: double(human: "Item")))
      end

      before do
        CommandPost::ApplicationHelper::DISPLAY_METHODS.each do |method|
          allow(minimal_record).to receive(:respond_to?).with(method).and_return(false)
        end
      end

      it "returns fallback label" do
        expect(helper.display_record_label(minimal_record)).to eq("Item #123")
      end
    end
  end

  describe "#filter_options_for" do
    context "with select filter on enum column" do
      let(:filter) { { name: :status, type: :select } }

      it "returns enum options" do
        options = helper.filter_options_for(LicenseResource, filter)

        expect(options).to include(["Active", "active"])
        expect(options).to include(["Expired", "expired"])
      end
    end

    context "with select filter with custom options" do
      let(:filter) { { name: :role, type: :select, options: [%w[Admin admin], %w[User user]] } }

      it "returns custom options" do
        options = helper.filter_options_for(UserResource, filter)

        expect(options).to eq([%w[Admin admin], %w[User user]])
      end
    end

    context "with select filter on regular column" do
      before do
        create(:user, role: "admin")
        create(:user, role: "user")
      end

      let(:filter) { { name: :role, type: :select } }

      it "returns distinct values" do
        options = helper.filter_options_for(UserResource, filter)

        expect(options).to include(["Admin", "admin"])
        expect(options).to include(["User", "user"])
      end
    end

    context "with boolean filter" do
      let(:filter) { { name: :active, type: :boolean } }

      it "returns yes/no options" do
        options = helper.filter_options_for(UserResource, filter)

        expect(options).to eq([%w[Yes true], %w[No false]])
      end
    end

    context "with unknown filter type" do
      let(:filter) { { name: :name, type: :unknown } }

      it "returns empty array" do
        expect(helper.filter_options_for(UserResource, filter)).to eq([])
      end
    end
  end

  describe "#badge_color_classes" do
    it "returns color classes for known color" do
      result = helper.send(:badge_color_classes, :green)

      expect(result).to include("bg-green")
    end

    it "returns gray classes for unknown color" do
      result = helper.send(:badge_color_classes, :nonexistent)

      expect(result).to include("bg-gray")
    end
  end
end
