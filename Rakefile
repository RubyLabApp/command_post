require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task default: :spec

namespace :db do
  desc "Load test database schema"
  task setup: :environment do
    require_relative "spec/dummy/config/environment"
    ActiveRecord::Schema.verbose = false
    load File.expand_path("spec/dummy/db/schema.rb", __dir__)
  end
end

task spec: "db:setup"
