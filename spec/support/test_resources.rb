# Aliases for test resources to maintain backwards compatibility in specs
TestUserResource = IronAdmin::Resources::UserResource
TestLicenseResource = IronAdmin::Resources::LicenseResource

module TestResourceHelpers
  def register_test_resources
    IronAdmin::ResourceRegistry.register(IronAdmin::Resources::UserResource)
    IronAdmin::ResourceRegistry.register(IronAdmin::Resources::LicenseResource)
  end
end

RSpec.configure do |config|
  config.include TestResourceHelpers
end
