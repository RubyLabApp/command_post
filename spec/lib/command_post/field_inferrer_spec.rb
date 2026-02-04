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
  end
end
