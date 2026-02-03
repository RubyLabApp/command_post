# Configuration Reference

```ruby
CommandPost.configure do |config|
  # --- General ---
  config.title = "Admin"
  config.logo = nil
  config.per_page = 25
  config.default_sort = :created_at
  config.default_sort_direction = :desc
  config.search_engine = :default

  # --- Badge Colors ---
  config.badge_colors = {
    green: "bg-green-100 text-green-800",
    red: "bg-red-100 text-red-800",
    yellow: "bg-yellow-100 text-yellow-800",
    blue: "bg-blue-100 text-blue-800",
    indigo: "bg-indigo-100 text-indigo-800",
    purple: "bg-purple-100 text-purple-800",
    pink: "bg-pink-100 text-pink-800",
    orange: "bg-orange-100 text-orange-800",
    teal: "bg-teal-100 text-teal-800",
    gray: "bg-gray-100 text-gray-800"
  }

  # --- Authentication ---
  config.authenticate do |controller|
  end

  config.current_user do |controller|
  end

  # --- Audit Logging ---
  config.on_action do |event|
  end

  # --- Theme ---
  config.theme do |t|
  end

  # --- Components ---
  config.components.table = nil
  config.components.form = nil
  config.components.filter_bar = nil
  config.components.search = nil
  config.components.navbar = nil
  config.components.sidebar = nil
  config.components.shell = nil
  config.components.fields[:type] = nil
end
```

## Reset

```ruby
CommandPost.reset_configuration!
```
