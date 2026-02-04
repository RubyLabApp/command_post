# Dashboard

The dashboard is the landing page of your admin panel, displaying key metrics, charts, and recent activity.

## Creating a Dashboard

Create a dashboard class in `app/command_post/dashboards/`:

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

Define metrics using the `metric` DSL:

```ruby
metric :name, format: :format_type do
  # Return a number
end
```

### Metric Formats

| Format | Display |
|--------|---------|
| `:number` | Plain number with commas (1,234) |
| `:currency` | Dollar formatted ($1,234.00) |
| `:percentage` | Percentage (12.5%) |

### Metric Component

Metrics render using `CommandPost::Dashboards::MetricCardComponent`. Customize the display in your views:

```haml
= render CommandPost::Dashboards::MetricCardComponent.new(
  name: :total_users,
  value: User.count,
  format: :number
)
```

## Charts

Define charts for visualizing trends:

```ruby
chart :signups_over_time, type: :line do
  # Return chart data
end
```

### Chart Types

- `:line` - Line chart
- `:bar` - Bar chart
- `:pie` - Pie chart
- `:doughnut` - Doughnut chart

### Chart Component

Charts render using `CommandPost::Dashboards::ChartComponent`:

```haml
= render CommandPost::Dashboards::ChartComponent.new(
  title: "Monthly Signups",
  type: :line,
  data: [45, 52, 38, 67, 89, 95],
  labels: ["Jan", "Feb", "Mar", "Apr", "May", "Jun"],
  height: 300
)
```

## Recent Records

Show recent records from any resource:

```ruby
recent :resource_name, limit: 5, scope: -> { custom_scope }
```

The `resource_name` must match a registered resource's name (model's plural form).

### Recent Table Component

Recent records render using `CommandPost::Dashboards::RecentTableComponent`:

```haml
= render CommandPost::Dashboards::RecentTableComponent.new(
  resource_name: :user,
  records: User.order(created_at: :desc).limit(5)
)
```

## Stats Grid

Display multiple metrics in a responsive grid:

```haml
= render CommandPost::Dashboards::StatsGridComponent.new(columns: 4) do |grid|
  - grid.with_stat(
    label: "Total Users",
    value: User.count,
    change: "+12%",
    change_type: :positive,
    icon: "users"
  )
  - grid.with_stat(
    label: "Revenue",
    value: number_to_currency(Payment.sum(:amount)),
    change: "-3%",
    change_type: :negative
  )
  - grid.with_stat(label: "Active Sessions", value: session_count)
  - grid.with_stat(label: "Conversion", value: "4.2%")
```

## Activity Feed

Show recent activity timeline:

```haml
= render CommandPost::Dashboards::ActivityFeedComponent.new(title: "Recent Activity") do |feed|
  - @activities.each do |activity|
    - feed.with_item(
      description: activity.description,
      timestamp: activity.created_at,
      icon: "user",
      icon_color: :blue,
      href: activity_path(activity)
    )
```

## Quick Links

Add shortcut links to common actions:

```haml
= render CommandPost::Dashboards::QuickLinksComponent.new(title: "Quick Actions") do |links|
  - links.with_link(label: "New User", href: new_user_path, icon: "user-plus")
  - links.with_link(label: "Export", href: export_path, icon: "arrow-down-tray")
  - links.with_link(label: "Settings", href: settings_path, icon: "cog-6-tooth")
```

## Registration

Only one dashboard can be active. The last class to inherit from `CommandPost::Dashboard` becomes the active dashboard. Place your dashboard in `app/command_post/dashboards/`.

## Dashboard Components Reference

| Component | Purpose |
|-----------|---------|
| `MetricCardComponent` | Single metric display |
| `ChartComponent` | Charts (line, bar, pie) |
| `StatsGridComponent` | Grid of metrics |
| `RecentTableComponent` | Recent records table |
| `ActivityFeedComponent` | Activity timeline |
| `QuickLinksComponent` | Shortcut links |

See [Dashboard Components](../components/dashboard-components.md) for detailed documentation.
