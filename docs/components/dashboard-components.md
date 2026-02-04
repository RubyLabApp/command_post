# Dashboard Components

Widgets for building dashboard interfaces.

## ChartComponent

Charts using Chart.js (line, bar, pie, doughnut).

```ruby
CommandPost::Dashboards::ChartComponent.new(
  title: "Revenue",           # Required: chart title
  type: :line,                # Optional: :line, :bar, :pie, :doughnut
  data: [100, 200, 300],      # Optional: array of values
  labels: ["Jan", "Feb", "Mar"], # Optional: array of labels
  height: 300                 # Optional: chart height in pixels
)
```

**Example:**

```haml
= render CommandPost::Dashboards::ChartComponent.new(
  title: "Monthly Signups",
  type: :line,
  data: @monthly_signups.values,
  labels: @monthly_signups.keys,
  height: 250
)

= render CommandPost::Dashboards::ChartComponent.new(
  title: "Users by Role",
  type: :pie,
  data: @role_counts.values,
  labels: @role_counts.keys
)
```

---

## StatsGridComponent

Grid of metric cards.

```ruby
CommandPost::Dashboards::StatsGridComponent.new(
  columns: 4    # Optional: 2, 3, or 4 columns
)
```

**Slots:**
- `stats` - Individual stat items (renders `StatComponent`)

**StatComponent options:**
- `label` - Metric name
- `value` - Metric value
- `change` - Change indicator (e.g., "+12%")
- `change_type` - `:positive`, `:negative`, or `:neutral`
- `icon` - Heroicon name

**Example:**

```haml
= render CommandPost::Dashboards::StatsGridComponent.new(columns: 4) do |grid|
  - grid.with_stat(label: "Total Users", value: @total_users, change: "+12%", change_type: :positive)
  - grid.with_stat(label: "Revenue", value: number_to_currency(@revenue), change: "-3%", change_type: :negative)
  - grid.with_stat(label: "Active Sessions", value: @active_sessions)
  - grid.with_stat(label: "Conversion Rate", value: "4.2%", icon: "chart-bar")
```

---

## ActivityFeedComponent

Timeline of recent activity.

```ruby
CommandPost::Dashboards::ActivityFeedComponent.new(
  title: "Recent Activity"    # Optional: section title
)
```

**Slots:**
- `items` - Activity items (renders `ItemComponent`)

**ItemComponent options:**
- `description` - Activity description
- `timestamp` - Time or string
- `icon` - Heroicon name
- `icon_color` - `:green`, `:red`, `:blue`, `:yellow`, `:gray`
- `href` - Optional link

**Example:**

```haml
= render CommandPost::Dashboards::ActivityFeedComponent.new(title: "Recent Activity") do |feed|
  - @recent_activities.each do |activity|
    - feed.with_item(
      description: activity.description,
      timestamp: activity.created_at,
      icon: activity.icon,
      icon_color: activity.color,
      href: activity_path(activity)
    )
```

---

## QuickLinksComponent

Grid of shortcut links.

```ruby
CommandPost::Dashboards::QuickLinksComponent.new(
  title: "Quick Links"    # Optional: section title
)
```

**Slots:**
- `links` - Link items (renders `LinkComponent`)

**LinkComponent options:**
- `label` - Link text
- `href` - Link URL
- `icon` - Heroicon name
- `description` - Optional description

**Example:**

```haml
= render CommandPost::Dashboards::QuickLinksComponent.new(title: "Quick Actions") do |links|
  - links.with_link(label: "New User", href: new_user_path, icon: "user-plus", description: "Create a new user account")
  - links.with_link(label: "Export Data", href: export_path, icon: "arrow-down-tray")
  - links.with_link(label: "Settings", href: settings_path, icon: "cog-6-tooth")
```

---

## MetricCardComponent

Single metric display card.

```ruby
CommandPost::Dashboards::MetricCardComponent.new(
  name: :total_users,         # Required: metric name
  value: 1234,                # Required: metric value
  format: :number             # Optional: :number, :currency, :percentage
)
```

**Example:**

```haml
= render CommandPost::Dashboards::MetricCardComponent.new(
  name: :monthly_revenue,
  value: 15000.50,
  format: :currency
)
```

---

## RecentTableComponent

Table showing recent records from a resource.

```ruby
CommandPost::Dashboards::RecentTableComponent.new(
  resource_name: :user,       # Required: resource name (singular)
  records: @recent_users      # Required: records to display
)
```

**Example:**

```haml
= render CommandPost::Dashboards::RecentTableComponent.new(
  resource_name: :order,
  records: Order.order(created_at: :desc).limit(5)
)
```

---

## Building a Dashboard

Combine components to create a complete dashboard:

```haml
.space-y-8
  -# Stats row
  = render CommandPost::Dashboards::StatsGridComponent.new(columns: 4) do |grid|
    - grid.with_stat(label: "Users", value: User.count)
    - grid.with_stat(label: "Revenue", value: number_to_currency(Payment.sum(:amount)), format: :currency)
    - grid.with_stat(label: "Orders", value: Order.count)
    - grid.with_stat(label: "Conversion", value: "3.2%")

  .grid.grid-cols-1.lg:grid-cols-2.gap-8
    -# Chart
    = render CommandPost::Dashboards::ChartComponent.new(
      title: "Signups Over Time",
      type: :line,
      data: @signup_data,
      labels: @signup_labels
    )

    -# Activity feed
    = render CommandPost::Dashboards::ActivityFeedComponent.new do |feed|
      - @activities.each do |a|
        - feed.with_item(description: a.message, timestamp: a.created_at)

  -# Recent tables
  .grid.grid-cols-1.lg:grid-cols-2.gap-8
    = render CommandPost::Dashboards::RecentTableComponent.new(
      resource_name: :user,
      records: User.order(created_at: :desc).limit(5)
    )

    = render CommandPost::Dashboards::RecentTableComponent.new(
      resource_name: :order,
      records: Order.order(created_at: :desc).limit(5)
    )
```
