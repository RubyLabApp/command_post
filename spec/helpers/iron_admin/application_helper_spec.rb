require "rails_helper"

RSpec.describe IronAdmin::ApplicationHelper, type: :helper do
  before do
    IronAdmin::ResourceRegistry.register(IronAdmin::Resources::UserResource)
    IronAdmin::ResourceRegistry.register(IronAdmin::Resources::LicenseResource)
  end

  describe "#display_field_value" do
    let(:user) { create(:user, name: "John Doe", email: "john@example.com") }

    context "with regular field" do
      let(:field) { IronAdmin::Field.new(:name, type: :text) }

      it "returns field value" do
        expect(helper.display_field_value(user, field)).to eq("John Doe")
      end
    end

    context "with belongs_to field" do
      let(:license) { create(:license, user: user) }
      let(:field) { IronAdmin::Field.new(:user, type: :belongs_to, display: :email) }

      it "displays associated record" do
        result = helper.display_field_value(license, field)

        expect(result).to include("john@example.com")
      end
    end

    context "with badge field" do
      let(:license) { create(:license, user: user, status: :active) }
      let(:field) { IronAdmin::Field.new(:status, type: :badge, colors: { active: :green }) }

      it "returns badge html" do
        result = helper.display_field_value(license, field)

        expect(result).to include("Active")
        expect(result).to include("rounded-full")
      end
    end

    context "with password field" do
      let(:field) { IronAdmin::Field.new(:password_hash, type: :password) }

      it "returns masked dots" do
        result = helper.display_field_value(user, field)

        expect(result).to include("\u2022" * 8)
        expect(result).not_to include(user.name)
      end

      it "never reveals the actual value" do
        document = create(:document, password_hash: "secret123")
        result = helper.display_field_value(document, field)

        expect(result).not_to include("secret123")
      end
    end

    context "with file field" do
      let(:document) { create(:document) }
      let(:field) { IronAdmin::Field.new(:cover_image, type: :file) }

      it "returns nil when no attachment" do
        expect(helper.display_field_value(document, field)).to be_nil
      end

      it "returns filename when file is attached" do
        document.cover_image.attach(
          io: StringIO.new("test"),
          filename: "test.pdf",
          content_type: "application/pdf"
        )

        result = helper.display_field_value(document, field)

        expect(result).to include("test.pdf")
      end
    end

    context "with files field" do
      let(:document) { create(:document) }
      let(:field) { IronAdmin::Field.new(:attachments, type: :files) }

      it "returns nil when no attachments" do
        expect(helper.display_field_value(document, field)).to be_nil
      end

      it "returns filenames when files are attached" do
        document.attachments.attach(
          io: StringIO.new("doc1"),
          filename: "first.pdf",
          content_type: "application/pdf"
        )
        document.attachments.attach(
          io: StringIO.new("doc2"),
          filename: "second.pdf",
          content_type: "application/pdf"
        )

        result = helper.display_field_value(document, field)

        expect(result).to include("first.pdf")
        expect(result).to include("second.pdf")
      end
    end

    context "with hidden field" do
      let(:widget) { create(:widget, secret_token: "abc123") }
      let(:field) { IronAdmin::Field.new(:secret_token, type: :hidden) }

      it "returns nil" do
        expect(helper.display_field_value(widget, field)).to be_nil
      end
    end

    context "with rich_text field" do
      let(:document) { create(:document) }
      let(:field) { IronAdmin::Field.new(:content, type: :rich_text) }

      it "returns nil when content is blank" do
        expect(helper.display_field_value(document, field)).to be_nil
      end

      it "renders rich text content" do
        document.update!(content: "Hello <strong>world</strong>")

        result = helper.display_field_value(document, field)

        expect(result).to include("prose")
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
      let(:minimal_record_class) do
        model_name = Struct.new(:human).new("Item")
        Struct.new(:id, :model_name, keyword_init: true) do
          define_method(:class) { Struct.new(:model_name).new(model_name) }
        end
      end
      let(:minimal_record) { minimal_record_class.new(id: 123) }

      it "returns fallback label" do
        expect(helper.display_record_label(minimal_record)).to eq("Item #123")
      end
    end
  end

  describe "#filter_options_for" do
    context "with select filter on enum column" do
      let(:filter) { { name: :status, type: :select } }

      it "returns enum options" do
        options = helper.filter_options_for(IronAdmin::Resources::LicenseResource, filter)

        expect(options).to include(%w[Active active])
        expect(options).to include(%w[Expired expired])
      end
    end

    context "with select filter with custom options" do
      let(:filter) { { name: :role, type: :select, options: [%w[Admin admin], %w[User user]] } }

      it "returns custom options" do
        options = helper.filter_options_for(IronAdmin::Resources::UserResource, filter)

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
        options = helper.filter_options_for(IronAdmin::Resources::UserResource, filter)

        expect(options).to include(%w[Admin admin])
        expect(options).to include(%w[User user])
      end
    end

    context "with boolean filter" do
      let(:filter) { { name: :active, type: :boolean } }

      it "returns yes/no options" do
        options = helper.filter_options_for(IronAdmin::Resources::UserResource, filter)

        expect(options).to eq([%w[Yes true], %w[No false]])
      end
    end

    context "with unknown filter type" do
      let(:filter) { { name: :name, type: :unknown } }

      it "returns empty array" do
        expect(helper.filter_options_for(IronAdmin::Resources::UserResource, filter)).to eq([])
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
