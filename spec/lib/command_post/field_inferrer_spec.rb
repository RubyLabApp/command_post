require "rails_helper"

RSpec.describe CommandPost::FieldInferrer do
  describe ".call" do
    subject(:fields) { described_class.call(User) }

    it "returns Field objects" do
      expect(fields).to all(be_a(CommandPost::Field))
    end

    it "infers string columns as text type" do
      email_field = fields.find { |f| f.name == :email }
      expect(email_field.type).to eq(:text)
    end

    it "infers boolean columns as boolean type" do
      field = fields.find { |f| f.name == :active }
      expect(field.type).to eq(:boolean)
    end

    it "infers datetime columns as datetime type" do
      field = fields.find { |f| f.name == :created_at }
      expect(field.type).to eq(:datetime)
    end

    it "includes expected columns" do
      names = fields.map(&:name)
      expect(names).to include(:id)
      expect(names).to include(:name)
      expect(names).to include(:email)
    end

    context "with enum columns" do
      subject(:fields) { described_class.call(License) }

      it "detects enum columns as select type" do
        status_field = fields.find { |f| f.name == :status }
        expect(status_field.type).to eq(:select)
        expect(status_field.options[:choices]).to eq(License.statuses.keys)
      end
    end

    context "with ActiveStorage attachments" do
      subject(:fields) { described_class.call(Document) }

      it "detects has_one_attached as file type" do
        cover_field = fields.find { |f| f.name == :cover_image }
        expect(cover_field).to be_present
        expect(cover_field.type).to eq(:file)
      end

      it "detects has_many_attached as files type" do
        docs_field = fields.find { |f| f.name == :attachments }
        expect(docs_field).to be_present
        expect(docs_field.type).to eq(:files)
      end
    end

    context "with ActionText rich text" do
      subject(:fields) { described_class.call(Document) }

      it "detects has_rich_text as rich_text type" do
        content_field = fields.find { |f| f.name == :content }
        expect(content_field).to be_present
        expect(content_field.type).to eq(:rich_text)
      end
    end

    context "with model without attachments or rich text" do
      subject(:fields) { described_class.call(User) }

      it "does not include attachment fields" do
        expect(fields.select { |f| f.type == :file }).to be_empty
        expect(fields.select { |f| f.type == :files }).to be_empty
      end

      it "does not include rich text fields" do
        expect(fields.select { |f| f.type == :rich_text }).to be_empty
      end
    end
  end
end
