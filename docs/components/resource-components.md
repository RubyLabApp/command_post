# Resource Components

Components for displaying and managing resource data.

## DataTableComponent

Sortable data table with records.

```ruby
IronAdmin::Resources::DataTableComponent.new(
  records: @users,                # Required: collection of records
  fields: fields,                 # Required: array of Field objects
  resource_class: UserResource,   # Required: resource class
  base_url: "/admin/users?",      # Required: base URL for sort links
  current_sort: nil,              # Optional: current sort column
  current_direction: nil          # Optional: current sort direction ("asc"/"desc")
)
```

**Example:**

```haml
= render IronAdmin::Resources::DataTableComponent.new(
  records: @users,
  fields: UserResource.resolved_fields.first(5),
  resource_class: UserResource,
  base_url: request.fullpath.split("?").first + "?",
  current_sort: params[:sort],
  current_direction: params[:direction]
)
```

---

## ShowFieldComponent

Display a single field value (dt/dd format).

```ruby
IronAdmin::Resources::ShowFieldComponent.new(
  field: field,      # Required: Field object
  record: @user      # Required: record to display
)
```

**Example:**

```haml
%dl
  - @fields.each do |field|
    = render IronAdmin::Resources::ShowFieldComponent.new(
      field: field,
      record: @user
    )
```

---

## ActionsComponent

Custom actions for a record.

```ruby
IronAdmin::Resources::ActionsComponent.new(
  actions: actions,              # Required: array of action hashes
  record: @user,                 # Required: record for actions
  resource_class: UserResource   # Required: resource class
)
```

**Action hash structure:**

```ruby
{
  name: :archive,
  label: "Archive",
  icon: "archive-box",
  confirm: true
}
```

**Example:**

```haml
= render IronAdmin::Resources::ActionsComponent.new(
  actions: UserResource.defined_actions,
  record: @user,
  resource_class: UserResource
)
```

---

## BreadcrumbComponent

Navigation breadcrumbs.

```ruby
IronAdmin::Resources::BreadcrumbComponent.new
```

**Slots:**
- `items` - Breadcrumb items (renders `ItemComponent`)

**ItemComponent options:**
- `label` - Display text
- `href` - Link URL (optional)
- `current` - Mark as current page (no link, aria-current)

**Example:**

```haml
= render IronAdmin::Resources::BreadcrumbComponent.new do |breadcrumb|
  - breadcrumb.with_item(label: "Dashboard", href: dashboard_path)
  - breadcrumb.with_item(label: "Users", href: users_path)
  - breadcrumb.with_item(label: @user.name, current: true)
```

---

## BulkActionsComponent

Actions for selected records.

```ruby
IronAdmin::Resources::BulkActionsComponent.new(
  actions: bulk_actions,         # Required: array of bulk action hashes
  resource_class: UserResource   # Required: resource class
)
```

**Example:**

```haml
= render IronAdmin::Resources::BulkActionsComponent.new(
  actions: UserResource.defined_bulk_actions,
  resource_class: UserResource
)
```

---

## RelatedListComponent

Display has_many associations.

```ruby
IronAdmin::Resources::RelatedListComponent.new(
  association: association,      # Required: association hash
  records: @user.posts,          # Required: related records
  limit: 20                      # Optional: max records to show
)
```

**Association hash structure:**

```ruby
{
  name: :posts,
  resource: PostResource,
  display: :title
}
```

**Example:**

```haml
= render IronAdmin::Resources::RelatedListComponent.new(
  association: { name: :orders, resource: OrderResource, display: :number },
  records: @user.orders,
  limit: 10
)
```
