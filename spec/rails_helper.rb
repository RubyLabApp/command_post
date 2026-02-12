require "spec_helper"
ENV["RAILS_ENV"] ||= "test"

require_relative "dummy/config/environment"

abort("The Rails environment is running in production mode!") if Rails.env.production?
require "rspec/rails"
require "factory_bot_rails"
require "view_component/test_helpers"

Dir[File.join(__dir__, "support/**/*.rb")].each { |f| require f }

# Load schema before tests run
ActiveRecord::Schema.verbose = false
load File.expand_path("dummy/db/schema.rb", __dir__)

# Load test resources
require_relative "dummy/app/command_post/user_resource"
require_relative "dummy/app/command_post/license_resource"
require_relative "dummy/app/command_post/post_resource"
require_relative "dummy/app/command_post/document_resource"
require_relative "dummy/app/command_post/profile_resource"
require_relative "dummy/app/command_post/tag_resource"
require_relative "dummy/app/command_post/note_resource"

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.include FactoryBot::Syntax::Methods
  config.include CommandPost::Engine.routes.url_helpers, type: :request
  config.include ViewComponent::TestHelpers, type: :component
  config.include CommandPost::Engine.routes.url_helpers, type: :component

  config.before do
    CommandPost.reset_configuration!
    CommandPost::ResourceRegistry.reset!
    CommandPost::AuditLog.clear!
    CommandPost::FieldTypeRegistry.reset!
    CommandPost::ToolRegistry.reset!
  end

  config.before(:each, type: :request) do
    # Re-register resources for request specs
    CommandPost::ResourceRegistry.register(UserResource)
    CommandPost::ResourceRegistry.register(LicenseResource)
    CommandPost::ResourceRegistry.register(NoteResource)
  end

  config.before(:each, type: :component) do
    # Re-register resources for component specs
    CommandPost::ResourceRegistry.register(UserResource)
    CommandPost::ResourceRegistry.register(LicenseResource)
    CommandPost::ResourceRegistry.register(NoteResource)

    # Set up route helpers for component tests
    vc_test_controller.view_context.class.define_method(:command_post) do
      CommandPost::Engine.routes.url_helpers
    end
  end
end
