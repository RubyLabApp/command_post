require_relative "lib/command_post/version"

Gem::Specification.new do |spec|
  spec.name        = "command-post"
  spec.version     = CommandPost::VERSION
  spec.authors     = [ "RubyLab" ]
  spec.summary     = "Convention-over-configuration admin panel engine for Rails"
  spec.homepage    = "https://github.com/rubylab/command-post"
  spec.license     = "MIT"

  spec.required_ruby_version = ">= 3.2"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,docs,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.1"
  spec.add_dependency "view_component", ">= 3.0"
  spec.add_dependency "turbo-rails", ">= 2.0"
  spec.add_dependency "stimulus-rails", ">= 1.3"
  spec.add_dependency "pagy", ">= 6.0"
  spec.add_dependency "haml-rails", ">= 2.0"
  spec.add_dependency "heroicon", ">= 1.0"
end
