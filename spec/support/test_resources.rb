# Aliases for test resources to maintain backwards compatibility in specs
TestUserResource = UserResource
TestLicenseResource = LicenseResource

module TestResourceHelpers
  def register_test_resources
    CommandPost::ResourceRegistry.register(UserResource)
    CommandPost::ResourceRegistry.register(LicenseResource)
  end
end

RSpec.configure do |config|
  config.include TestResourceHelpers
end
