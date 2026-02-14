# Installation

## Requirements

- Ruby >= 3.2
- Rails >= 7.1
- Tailwind CSS (for default theme classes)

## Step 1: Add the Gem

Add IronAdmin to your `Gemfile`:

```ruby
# From a local path:
gem "iron_admin", path: "/path/to/iron_admin"

# Or if published to a gem server:
gem "iron_admin"
```

Then run:

```bash
bundle install
```

## Step 2: Run the Install Generator

```bash
rails generate iron_admin:install
```

This creates:

| File | Purpose |
|------|---------|
| `config/initializers/iron_admin.rb` | Main configuration (title, auth, theme) |
| `app/iron_admin/dashboards/` | Directory for dashboard definitions |
| `app/iron_admin/resources/` | Directory for resource definitions |
| `app/iron_admin/dashboard.rb` | Default dashboard class |

It also mounts the engine in `config/routes.rb`.

## Step 3: Mount the Engine (if not auto-mounted)

In `config/routes.rb`:

```ruby
Rails.application.routes.draw do
  mount IronAdmin::Engine => "/admin"
end
```

## Step 4: Configure Authentication

Edit `config/initializers/iron_admin.rb`:

```ruby
IronAdmin.configure do |config|
  config.title = "My App Admin"

  config.authenticate do |controller|
    unless controller.session[:user_id]
      controller.redirect_to "/login"
    end
  end

  config.current_user do |controller|
    User.find_by(id: controller.session[:user_id])
  end
end
```

## Step 5: Create Your First Resource

```bash
rails generate iron_admin:resource User
```

This creates `app/iron_admin/resources/user_resource.rb`. IronAdmin automatically infers fields from your model's database schema.

## Step 6: Visit the Admin Panel

Start your server and navigate to `/admin`.

## Dependencies

IronAdmin depends on the following gems (installed automatically):

| Gem | Version | Purpose |
|-----|---------|---------|
| `rails` | >= 7.1 | Framework |
| `view_component` | >= 3.0 | UI components |
| `turbo-rails` | >= 2.0 | Hotwire Turbo |
| `stimulus-rails` | >= 1.3 | Hotwire Stimulus |
| `pagy` | >= 6.0 | Pagination |
| `haml-rails` | >= 2.0 | Template engine |
| `heroicon` | >= 1.0 | SVG icons |

## Tailwind CSS Setup

IronAdmin uses Tailwind CSS classes for all styling. Ensure your Tailwind configuration includes the engine's view paths in the `content` array so that all CSS classes are properly compiled.

Add the path to the engine's app directory in your `tailwind.config.js`:

```js
module.exports = {
  content: [
    // ... your app paths
    "./path/to/iron_admin/app/**/*.{rb,haml}",
  ],
}
```

If installed as a gem, use `bundle show iron_admin` to find the installed path and add it to your Tailwind content paths.
