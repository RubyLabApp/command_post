# Filter Components

Components for filtering and searching data.

## SearchComponent

Search input with icon.

```ruby
CommandPost::Filters::SearchComponent.new(
  form_url: "/admin/users",    # Required: form submit URL
  placeholder: "Search...",    # Optional: placeholder text
  value: nil,                  # Optional: current search query
  hidden_params: {}            # Optional: hidden form params to preserve
)
```

**Example:**

```haml
= render CommandPost::Filters::SearchComponent.new(
  form_url: resources_path,
  placeholder: "Search users...",
  value: params[:q],
  hidden_params: { scope: params[:scope] }
)
```

---

## SelectFilterComponent

Dropdown filter for categorical data.

```ruby
CommandPost::Filters::SelectFilterComponent.new(
  name: :status,               # Required: filter parameter name
  options: options,            # Required: array of [label, value] pairs
  label: nil,                  # Optional: label text (auto-generated from name)
  selected: nil                # Optional: currently selected value
)
```

**Example:**

```haml
= render CommandPost::Filters::SelectFilterComponent.new(
  name: :role,
  options: [["Admin", "admin"], ["User", "user"], ["Guest", "guest"]],
  label: "User Role",
  selected: params.dig(:filters, :role)
)
```

---

## DateRangeComponent

Date range filter with from/to inputs.

```ruby
CommandPost::Filters::DateRangeComponent.new(
  name: :created_at,           # Required: filter parameter name
  label: nil,                  # Optional: label text (auto-generated from name)
  from_value: nil,             # Optional: from date value
  to_value: nil                # Optional: to date value
)
```

**Example:**

```haml
= render CommandPost::Filters::DateRangeComponent.new(
  name: :created_at,
  label: "Created Between",
  from_value: params.dig(:filters, :created_at_from),
  to_value: params.dig(:filters, :created_at_to)
)
```

---

## BarComponent

Container for filter controls with dropdown behavior.

```ruby
CommandPost::Filters::BarComponent.new(
  form_url: "/admin/users",    # Required: form submit URL
  scope: nil,                  # Optional: current scope
  query: nil,                  # Optional: current search query
  active_count: 0              # Optional: number of active filters
)
```

**Slots:**
- `filters` - Individual filter components

**Example:**

```haml
= render CommandPost::Filters::BarComponent.new(
  form_url: resources_path,
  active_count: @active_filter_count
) do |bar|

  - bar.with_filter do
    = render CommandPost::Filters::SelectFilterComponent.new(
      name: :status,
      options: status_options,
      selected: params.dig(:filters, :status)
    )

  - bar.with_filter do
    = render CommandPost::Filters::DateRangeComponent.new(
      name: :created_at,
      from_value: params.dig(:filters, :created_at_from),
      to_value: params.dig(:filters, :created_at_to)
    )
```

---

## Combining Filters

Typical filter bar setup:

```haml
.flex.items-center.gap-4
  -# Search
  = render CommandPost::Filters::SearchComponent.new(
    form_url: resources_path,
    value: params[:q]
  )

  -# Filter dropdown
  = render CommandPost::Filters::BarComponent.new(
    form_url: resources_path,
    active_count: active_filter_count
  ) do |bar|

    - bar.with_filter do
      = render CommandPost::Filters::SelectFilterComponent.new(
        name: :role,
        options: role_options
      )

    - bar.with_filter do
      = render CommandPost::Filters::DateRangeComponent.new(
        name: :created_at
      )
```
