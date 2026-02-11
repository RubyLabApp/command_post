require_relative "boot"

require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_text/engine"
require "action_view/railtie"

Bundler.require(*Rails.groups)
require "command_post"

module Dummy
  class Application < Rails::Application
    config.root = File.expand_path("..", __dir__)
    config.load_defaults Rails::VERSION::STRING.to_f
    config.eager_load = false
    config.hosts = []
    config.active_storage.service = :test
    config.active_job.queue_adapter = :inline
  end
end
