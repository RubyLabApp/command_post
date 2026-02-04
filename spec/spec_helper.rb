require "simplecov"
require "simplecov-console"

SimpleCov.start "rails" do
  add_filter "/spec/"
  add_filter "/lib/generators/"
  add_filter "/lib/command_post/version.rb"

  add_group "Lib", "lib/command_post"
  add_group "Controllers", "app/controllers"
  add_group "Components", "app/components"
  add_group "Helpers", "app/helpers"

  minimum_coverage 95
  minimum_coverage_by_file 80

  formatter SimpleCov::Formatter::MultiFormatter.new([
                                                       SimpleCov::Formatter::HTMLFormatter,
                                                       SimpleCov::Formatter::Console,
                                                     ])
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.filter_run_when_matching :focus
  config.example_status_persistence_file_path = "spec/examples.txt"
  config.disable_monkey_patching!
  config.order = :random
  Kernel.srand config.seed
end
