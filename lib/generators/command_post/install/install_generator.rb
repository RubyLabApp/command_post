module CommandPost
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      def create_command_post_directory
        empty_directory "app/command_post"
      end

      def copy_initializer
        template "initializer.rb.tt", "config/initializers/command_post.rb"
      end

      def copy_dashboard
        template "dashboard.rb.tt", "app/command_post/dashboard.rb"
      end

      def add_route
        route 'mount CommandPost::Engine => "/admin"'
      end
    end
  end
end
