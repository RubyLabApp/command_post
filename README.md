# CommandPost

[![Gem Version](https://badge.fury.io/rb/command-post.svg)](https://badge.fury.io/rb/command-post)
[![CI](https://github.com/rubylab/command-post/actions/workflows/ci.yml/badge.svg)](https://github.com/rubylab/command-post/actions/workflows/ci.yml)
[![Ruby Style Guide](https://img.shields.io/badge/code_style-rubocop-brightgreen.svg)](https://github.com/rubocop/rubocop)

Convention-over-configuration admin panel engine for Ruby on Rails. Build beautiful admin interfaces with minimal code.

## Features

- **Zero Configuration CRUD** - Auto-generates forms and tables from your database schema
- **Resource DSL** - Customize fields, filters, scopes, and actions with a clean Ruby DSL
- **Dashboard Builder** - Create metrics, charts, and recent records widgets
- **Theme System** - Fully customizable Tailwind CSS classes for every UI element
- **Authorization** - Built-in policy system for fine-grained access control
- **Search** - Global search across all resources
- **Export** - CSV and JSON export out of the box

## Requirements

- Ruby >= 3.2
- Rails >= 7.1

## Installation

Add to your Gemfile:

```ruby
gem "command-post"
```

Then run:

```bash
bundle install
rails generate command_post:install
```

Mount the engine in your `config/routes.rb`:

```ruby
Rails.application.routes.draw do
  mount CommandPost::Engine, at: "/admin"
end
```

## Quick Start

### 1. Configure Authentication

```ruby
# config/initializers/command_post.rb
CommandPost.configure do |config|
  config.title = "My App Admin"

  config.authenticate do |controller|
    user = User.find_by(id: controller.session[:user_id])
    controller.redirect_to "/login" unless user&.admin?
  end

  config.current_user do |controller|
    User.find_by(id: controller.session[:user_id])
  end
end
```

### 2. Generate Resources

```bash
rails generate command_post:resource User
rails generate command_post:resource Product
rails generate command_post:resource Order
```

### 3. Customize Resources

```ruby
# app/command_post/user_resource.rb
class UserResource < CommandPost::Resource
  field :role, type: :badge, colors: { admin: :purple, user: :blue }
  field :email, type: :text

  searchable :name, :email

  filter :role, type: :select, choices: User.roles.keys
  filter :created_at, type: :date_range

  scope :admins, -> { where(role: :admin) }
  scope :recent, -> { where("created_at > ?", 7.days.ago) }

  index_fields :id, :name, :email, :role, :created_at
  form_fields :name, :email, :role

  menu priority: 1, icon: "users", group: "People"

  action :lock, icon: "lock-closed", confirm: true do |record|
    record.update!(locked_at: Time.current)
  end
end
```

### 4. Create a Dashboard

```ruby
# app/command_post/admin_dashboard.rb
class AdminDashboard < CommandPost::Dashboard
  metric :total_users, format: :number do
    User.count
  end

  metric :monthly_revenue, format: :currency do
    Payment.where("created_at > ?", 30.days.ago).sum(:amount)
  end

  recent :users, limit: 5, scope: -> { order(created_at: :desc) }
  recent :payments, limit: 5
end
```

Visit `/admin` and your admin panel is ready!

## Documentation

Full documentation is available in the [docs](docs/) directory:

- [Installation](docs/getting-started/installation.md)
- [Quick Start](docs/getting-started/quick-start.md)
- [Resources Guide](docs/guides/resources.md)
- [Dashboard Guide](docs/guides/dashboard.md)
- [Theming Guide](docs/guides/theming.md)
- [Configuration Reference](docs/reference/configuration.md)

## Development

After checking out the repo:

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for details.

## License

The gem is available as open source under the terms of the [MIT License](MIT-LICENSE).
