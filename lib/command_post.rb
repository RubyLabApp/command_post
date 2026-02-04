require "command_post/version"
require "command_post/configuration"
require "command_post/field"
require "command_post/field_inferrer"
require "command_post/resource"
require "command_post/resource_registry"
require "command_post/policy"
require "command_post/dashboard"
require "command_post/audit_log"
require "command_post/engine"

module CommandPost
  class << self
    attr_accessor :dashboard_class

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield configuration
    end

    def reset_configuration!
      @configuration = Configuration.new
      @dashboard_class = nil
    end
  end
end
