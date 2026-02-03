require "pagy"
require "view_component"
require "heroicon"
require "haml-rails"
require "turbo-rails"
require "stimulus-rails"

module CommandPost
  class Engine < ::Rails::Engine
    isolate_namespace CommandPost

    initializer "command_post.assets" do |app|
      app.config.assets.precompile += %w[command_post_manifest] if app.config.respond_to?(:assets) && app.config.assets
    end

    config.after_initialize do
      resource_path = Rails.root.join("app/command_post")
      Rails.autoloaders.main.eager_load_dir(resource_path.to_s) if resource_path.exist?
    end
  end
end
