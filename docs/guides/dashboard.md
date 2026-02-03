# Dashboard

The dashboard is the landing page of your admin panel.

## Creating a Dashboard

```ruby
# app/command_post/dashboards/admin_dashboard.rb
class AdminDashboard < CommandPost::Dashboard
  metric :total_users, format: :number do
    User.count
  end

  metric :monthly_revenue, format: :currency do
    Payment.where("created_at > ?", 30.days.ago).sum(:amount)
  end

  metric :conversion_rate, format: :percentage do
    total = User.count
    paying = User.joins(:subscriptions).distinct.count
    total.zero? ? 0 : (paying.to_f / total * 100).round(1)
  end

  recent :users, limit: 5, scope: -> { order(created_at: :desc) }
  recent :payments, limit: 10
end
```

## Metrics

```ruby
metric :name, format: :format_type do
  # Return a number
end
```

### Metric Formats

| Format | Display |
|--------|---------|
| `:number` | Plain number with commas |
| `:currency` | Dollar formatted |
| `:percentage` | Percentage |

## Charts

```ruby
chart :signups_over_time, type: :line do
  # Return chart data
end
```

## Recent Records

```ruby
recent :resource_name, limit: 5, scope: -> { custom_scope }
```

The `resource_name` must match a registered resource's `resource_name` (model's plural name).

## Registration

Only one dashboard can be active. The last class to inherit from `CommandPost::Dashboard` becomes the active dashboard. Place your dashboard in `app/command_post/dashboards/`.
