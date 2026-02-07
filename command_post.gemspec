require_relative "lib/command_post/version"

Gem::Specification.new do |spec|
  spec.name        = "command-post"
  spec.version     = CommandPost::VERSION
  spec.authors     = ["RubyLab"]
  spec.summary     = "Convention-over-configuration admin panel engine for Rails"
  spec.description = "CommandPost is a convention-over-configuration admin panel engine for Ruby on Rails " \
                     "that automatically generates CRUD interfaces from your models with built-in support " \
                     "for search, filters, scopes, custom actions, theming, and policy-based authorization."
  spec.homepage    = "https://github.com/RubyLabApp/command_post"
  spec.license     = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/RubyLabApp/command_post"
  spec.metadata["changelog_uri"] = "https://github.com/RubyLabApp/command_post/blob/main/CHANGELOG.md"
  spec.metadata["github_repo"] = "ssh://github.com/RubyLabApp/command_post"

  spec.required_ruby_version = ">= 3.2"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,docs,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "haml-rails", ">= 2.0"
  spec.add_dependency "heroicon", ">= 1.0"
  spec.add_dependency "pagy", ">= 6.0"
  spec.add_dependency "rails", ">= 7.1"
  spec.add_dependency "stimulus-rails", ">= 1.3"
  spec.add_dependency "turbo-rails", ">= 2.0"
  spec.add_dependency "view_component", ">= 3.0"

  spec.add_development_dependency "factory_bot_rails", "~> 6.4"
  spec.add_development_dependency "rspec-rails", "~> 7.0"
  spec.add_development_dependency "rubocop", "~> 1.60"
  spec.add_development_dependency "rubocop-rails", "~> 2.23"
  spec.add_development_dependency "rubocop-rake", "~> 0.6"
  spec.add_development_dependency "rubocop-rspec", "~> 3.0"
  spec.add_development_dependency "simplecov", "~> 0.22"
  spec.add_development_dependency "simplecov-console", "~> 0.9"
  spec.add_development_dependency "sqlite3", "~> 2.0"
  spec.add_development_dependency "yard", "~> 0.9"
  spec.metadata["rubygems_mfa_required"] = "true"
end
