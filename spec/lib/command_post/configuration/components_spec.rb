require "rails_helper"

RSpec.describe CommandPost::Configuration::Components do
  subject(:components) { described_class.new }

  describe "initialization" do
    it "initializes fields as empty hash" do
      expect(components.fields).to eq({})
    end
  end

  describe "attr_accessors" do
    it "allows setting table" do
      components.table = "CustomTableComponent"

      expect(components.table).to eq("CustomTableComponent")
    end

    it "allows setting form" do
      components.form = "CustomFormComponent"

      expect(components.form).to eq("CustomFormComponent")
    end

    it "allows setting filter_bar" do
      components.filter_bar = "CustomFilterComponent"

      expect(components.filter_bar).to eq("CustomFilterComponent")
    end

    it "allows setting search" do
      components.search = "CustomSearchComponent"

      expect(components.search).to eq("CustomSearchComponent")
    end

    it "allows setting navbar" do
      components.navbar = "CustomNavbarComponent"

      expect(components.navbar).to eq("CustomNavbarComponent")
    end

    it "allows setting sidebar" do
      components.sidebar = "CustomSidebarComponent"

      expect(components.sidebar).to eq("CustomSidebarComponent")
    end

    it "allows setting shell" do
      components.shell = "CustomShellComponent"

      expect(components.shell).to eq("CustomShellComponent")
    end
  end

  describe "#fields" do
    it "is read-only" do
      expect(components).not_to respond_to(:fields=)
    end

    it "returns a hash" do
      expect(components.fields).to be_a(Hash)
    end
  end
end
