# Authentication & Authorization

CommandPost uses block-based authentication, compatible with any auth system.

## Authentication

### Basic Session Auth

```ruby
CommandPost.configure do |config|
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

### Admin-Only Access

```ruby
config.authenticate do |controller|
  user = User.find_by(id: controller.session[:user_id])
  unless user&.admin?
    controller.redirect_to "/login", alert: "Access denied"
  end
end
```

### With Devise

```ruby
config.authenticate do |controller|
  unless controller.current_user&.admin?
    controller.redirect_to controller.main_app.new_user_session_path
  end
end

config.current_user do |controller|
  controller.current_user
end
```

### Multi-Environment Redirects

```ruby
config.authenticate do |controller|
  user = User.find_by(id: controller.session[:user_id])
  unless user && user.admin? && user.email_verified?
    login_url = case Rails.env
    when "production" then "https://app.example.com/login"
    when "staging" then "https://staging.example.com/login"
    else "http://localhost:3000/login"
    end
    controller.redirect_to login_url, allow_other_host: true
  end
end
```

## The `current_user` Helper

The user returned by `config.current_user` is available as `command_post_current_user` in all CommandPost controllers and views.

## Policies

Per-resource access control:

```ruby
class UserResource < CommandPost::Resource
  policy do
    allow :read, :create, :update
    deny :delete, if: ->(record) { record.admin? }
  end
end
```

### Policy Actions

| Action | Covers |
|--------|--------|
| `:read` | Index and show |
| `:create` | New and create |
| `:update` | Edit and update |
| `:delete` | Destroy |

### Conditional Policies

- `allow` with `if:` receives the **current user**
- `deny` with `if:` receives the **record**

```ruby
policy do
  allow :read
  allow :update, if: ->(user) { user.admin? || user.manager? }
  deny :delete, if: ->(record) { record.protected? }
end
```

### CRUD Restrictions

For simple cases:

```ruby
class AuditLogResource < CommandPost::Resource
  deny_actions :create, :update, :delete
end
```

## Audit Logging

```ruby
config.on_action do |event|
  AuditLog.create!(
    user: event.user,
    action: event.action.to_s,
    target_type: event.resource.sub("Resource", ""),
    target_id: event.record_id,
    metadata: event.changes,
    ip_address: event.ip_address
  )
end
```

### Event Properties

| Property | Description |
|----------|-------------|
| `event.user` | Current admin user |
| `event.action` | Action performed |
| `event.resource` | Resource class name |
| `event.record_id` | ID of affected record |
| `event.changes` | Hash of changed attributes |
| `event.ip_address` | Client IP address |
