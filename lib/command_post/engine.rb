# frozen_string_literal: true

require "pagy"
require "view_component"
require "heroicon"
require "haml-rails"
require "turbo-rails"
require "stimulus-rails"

module CommandPost
  # Rails Engine that provides the admin panel functionality.
  #
  # The Engine is mounted in your application's routes to expose
  # the admin panel at a path of your choice (typically /admin).
  #
  # @example Mounting the engine in config/routes.rb
  #   Rails.application.routes.draw do
  #     mount CommandPost::Engine => "/admin"
  #   end
  #
  # @see file:docs/getting-started/installation.md Installation Guide
  class Engine < ::Rails::Engine
    isolate_namespace CommandPost

    initializer "command_post.assets" do |app|
      app.config.assets.precompile += %w[command_post_manifest] if app.config.respond_to?(:assets) && app.config.assets
    end

    initializer "command_post.importmap", before: "importmap" do |app|
      app.config.importmap.paths << root.join("config/importmap.rb") if app.config.respond_to?(:importmap)
    end

    initializer "command_post.i18n" do
      config.i18n.load_path += Dir[root.join("config", "locales", "**", "*.yml")]
    end

    config.after_initialize do
      resource_path = Rails.root.join("app/command_post")
      Rails.autoloaders.main.eager_load_dir(resource_path.to_s) if resource_path.exist?
    end
  end
end
