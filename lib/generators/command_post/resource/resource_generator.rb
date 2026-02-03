module CommandPost
  module Generators
    class ResourceGenerator < Rails::Generators::NamedBase
      source_root File.expand_path("templates", __dir__)

      def create_resource_file
        template "resource.rb.tt", File.join("app/command_post", class_path, "#{file_name}_resource.rb")
      end
    end
  end
end
