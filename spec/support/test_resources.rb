# Test resources are now in spec/dummy/app/command_post/
# This file provides helper methods for specs

module TestResourceHelpers
  def register_test_resources
    CommandPost::ResourceRegistry.register(UserResource)
    CommandPost::ResourceRegistry.register(LicenseResource)
  end
end

RSpec.configure do |config|
  config.include TestResourceHelpers
end
