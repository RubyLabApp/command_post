# Quick Start

Get a full admin panel running in 5 steps.

## 1. Install

```bash
bundle add command-post
rails generate command_post:install
```

## 2. Configure Authentication

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

## 3. Generate Resources

```bash
rails generate command_post:resource User
rails generate command_post:resource Product
rails generate command_post:resource Order
```

CommandPost infers all fields from your database schema automatically. No configuration needed for basic CRUD.

## 4. Customize a Resource

```ruby
# app/command_post/resources/user_resource.rb
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

## 5. Create a Dashboard

```ruby
# app/command_post/dashboards/admin_dashboard.rb
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

Visit `/admin` and your admin panel is ready.
