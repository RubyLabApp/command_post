require "rails_helper"
require_relative "../../../../app/components/command_post/filters/search_component"

RSpec.describe CommandPost::Filters::SearchComponent, type: :component do
  describe "#initialize" do
    it "has default placeholder" do
      component = described_class.new(form_url: "/search")
      expect(component.placeholder).to eq("Search...")
    end

    it "accepts custom placeholder" do
      component = described_class.new(form_url: "/search", placeholder: "Find users...")
      expect(component.placeholder).to eq("Find users...")
    end

    it "accepts value" do
      component = described_class.new(form_url: "/search", value: "test query")
      expect(component.value).to eq("test query")
    end

    it "accepts hidden_params" do
      component = described_class.new(form_url: "/search", hidden_params: { scope: "active" })
      expect(component.hidden_params).to eq({ scope: "active" })
    end
  end

  describe "#input_classes" do
    it "includes border class" do
      component = described_class.new(form_url: "/search")
      expect(component.input_classes).to include("border")
    end

    it "includes left padding for icon" do
      component = described_class.new(form_url: "/search")
      expect(component.input_classes).to include("pl-10")
    end
  end
end
