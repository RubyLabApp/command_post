# frozen_string_literal: true

require "rails_helper"
require "rails/generators"
require "generators/iron_admin/resource/resource_generator"

RSpec.describe IronAdmin::Generators::ResourceGenerator, type: :generator do
  let(:destination) { File.expand_path("../../tmp", __dir__) }

  before do
    FileUtils.rm_rf(destination)
    FileUtils.mkdir_p(destination)
  end

  after do
    FileUtils.rm_rf(destination)
  end

  def run_generator(args = [])
    described_class.start(args, destination_root: destination)
  end

  describe "generating a resource" do
    it "creates a resource file with the correct name" do
      run_generator(["User"])

      expect(File.exist?(File.join(destination, "app/iron_admin/resources/user_resource.rb"))).to be true
    end

    it "creates a resource file with correct content" do
      run_generator(["Product"])

      content = File.read(File.join(destination, "app/iron_admin/resources/product_resource.rb"))
      expect(content).to include("class ProductResource < IronAdmin::Resource")
      expect(content).to include("module IronAdmin")
      expect(content).to include("module Resources")
    end

    it "handles namespaced models" do
      run_generator(["Admin::User"])

      expect(File.exist?(File.join(destination, "app/iron_admin/resources/admin/user_resource.rb"))).to be true

      content = File.read(File.join(destination, "app/iron_admin/resources/admin/user_resource.rb"))
      expect(content).to include("class Admin::UserResource < IronAdmin::Resource")
      expect(content).to include("module IronAdmin")
      expect(content).to include("module Resources")
    end

    it "handles snake_case names" do
      run_generator(["order_item"])

      expect(File.exist?(File.join(destination, "app/iron_admin/resources/order_item_resource.rb"))).to be true

      content = File.read(File.join(destination, "app/iron_admin/resources/order_item_resource.rb"))
      expect(content).to include("class OrderItemResource < IronAdmin::Resource")
    end

    it "handles CamelCase names" do
      run_generator(["OrderItem"])

      expect(File.exist?(File.join(destination, "app/iron_admin/resources/order_item_resource.rb"))).to be true

      content = File.read(File.join(destination, "app/iron_admin/resources/order_item_resource.rb"))
      expect(content).to include("class OrderItemResource < IronAdmin::Resource")
    end
  end
end
