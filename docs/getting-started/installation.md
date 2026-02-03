# Installation

## Requirements

- Ruby >= 3.2
- Rails >= 7.1
- Tailwind CSS (for default theme classes)

## Step 1: Add the Gem

Add CommandPost to your `Gemfile`:

```ruby
# From a local path:
gem "command-post", path: "/path/to/command_post"

# Or if published to a gem server:
gem "command-post"
```

Then run:

```bash
bundle install
```

## Step 2: Run the Install Generator

```bash
rails generate command_post:install
```

This creates:

| File | Purpose |
|------|---------|
| `config/initializers/command_post.rb` | Main configuration (title, auth, theme) |
| `app/command_post/dashboards/` | Directory for dashboard definitions |
| `app/command_post/resources/` | Directory for resource definitions |
| `app/command_post/dashboard.rb` | Default dashboard class |

It also mounts the engine in `config/routes.rb`.

## Step 3: Mount the Engine (if not auto-mounted)

In `config/routes.rb`:

```ruby
Rails.application.routes.draw do
  mount CommandPost::Engine => "/admin"
end
```

## Step 4: Configure Authentication

Edit `config/initializers/command_post.rb`:

```ruby
CommandPost.configure do |config|
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
rails generate command_post:resource User
```

This creates `app/command_post/resources/user_resource.rb`. CommandPost automatically infers fields from your model's database schema.

## Step 6: Visit the Admin Panel

Start your server and navigate to `/admin`.

## Dependencies

CommandPost depends on the following gems (installed automatically):

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

CommandPost uses Tailwind CSS classes for all styling. Ensure your Tailwind configuration includes the engine's view paths in the `content` array so that all CSS classes are properly compiled.

Add the path to the engine's app directory in your `tailwind.config.js`:

```js
module.exports = {
  content: [
    // ... your app paths
    "./path/to/command_post/app/**/*.{rb,haml}",
  ],
}
```

If installed as a gem, use `bundle show command-post` to find the installed path and add it to your Tailwind content paths.
