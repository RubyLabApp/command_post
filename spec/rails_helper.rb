require "spec_helper"
ENV["RAILS_ENV"] ||= "test"

require_relative "dummy/config/environment"

abort("The Rails environment is running in production mode!") if Rails.env.production?
require "rspec/rails"
require "factory_bot_rails"

Dir[File.join(__dir__, "support/**/*.rb")].sort.each { |f| require f }

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.include FactoryBot::Syntax::Methods
  config.include CommandPost::Engine.routes.url_helpers, type: :request

  config.before(:each) do
    CommandPost.reset_configuration!
    CommandPost::ResourceRegistry.reset!
  end
end
