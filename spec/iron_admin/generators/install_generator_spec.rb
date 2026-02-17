# frozen_string_literal: true

require "rails_helper"
require "rails/generators"
require "generators/iron_admin/install/install_generator"

RSpec.describe IronAdmin::Generators::InstallGenerator, type: :generator do
  let(:destination) { File.expand_path("../../tmp", __dir__) }

  before do
    FileUtils.rm_rf(destination)
    FileUtils.mkdir_p(destination)
    FileUtils.mkdir_p(File.join(destination, "config"))
    # Create a minimal routes file for the generator to modify
    File.write(File.join(destination, "config/routes.rb"), "Rails.application.routes.draw do\nend\n")
  end

  after do
    FileUtils.rm_rf(destination)
  end

  def run_generator(args = [])
    described_class.start(args, destination_root: destination)
  end

  describe "running the install generator" do
    before { run_generator }

    it "creates the app/iron_admin/resources directory" do
      expect(Dir.exist?(File.join(destination, "app/iron_admin/resources"))).to be true
    end

    it "creates the app/iron_admin/dashboards directory" do
      expect(Dir.exist?(File.join(destination, "app/iron_admin/dashboards"))).to be true
    end

    it "creates the initializer" do
      initializer_path = File.join(destination, "config/initializers/iron_admin.rb")
      expect(File.exist?(initializer_path)).to be true
    end

    it "creates initializer with configuration block" do
      content = File.read(File.join(destination, "config/initializers/iron_admin.rb"))
      expect(content).to include("IronAdmin.configure do |config|")
      expect(content).to include("config.title")
    end

    it "creates the default dashboard" do
      dashboard_path = File.join(destination, "app/iron_admin/dashboards/admin_dashboard.rb")
      expect(File.exist?(dashboard_path)).to be true
    end

    it "creates dashboard with correct class" do
      content = File.read(File.join(destination, "app/iron_admin/dashboards/admin_dashboard.rb"))
      expect(content).to include("class AdminDashboard < IronAdmin::Dashboard")
      expect(content).to include("module IronAdmin")
      expect(content).to include("module Dashboards")
    end

    it "adds route to routes.rb" do
      content = File.read(File.join(destination, "config/routes.rb"))
      expect(content).to include('mount IronAdmin::Engine => "/admin"')
    end
  end
end
