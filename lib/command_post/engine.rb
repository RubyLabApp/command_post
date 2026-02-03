require "pagy"
require "view_component"
require "heroicon"

module CommandPost
  class Engine < ::Rails::Engine
    isolate_namespace CommandPost

    initializer "command_post.assets" do |app|
      if app.config.respond_to?(:assets) && app.config.assets
        app.config.assets.precompile += %w[command_post_manifest]
      end
    end

    config.after_initialize do
      resource_path = Rails.root.join("app", "command_post")
      if resource_path.exist?
        Rails.autoloaders.main.eager_load_dir(resource_path.to_s)
      end
    end
  end
end
