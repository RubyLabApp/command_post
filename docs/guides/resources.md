# Resources

Resources are the core building block of CommandPost. Each resource maps to an ActiveRecord model and defines how it appears in the admin panel.

## Generating a Resource

```bash
rails generate command_post:resource User
```

Creates `app/command_post/resources/user_resource.rb`:

```ruby
class UserResource < CommandPost::Resource
end
```

By convention, `UserResource` maps to the `User` model. To override:

```ruby
class UserResource < CommandPost::Resource
  self.model_class_override = Account
end
```

## Fields

Fields are automatically inferred from the database schema. Override specific fields:

```ruby
class UserResource < CommandPost::Resource
  field :status, type: :badge, colors: { active: :green, suspended: :red }
  field :bio, type: :textarea
  field :role, type: :select, choices: %w[user admin]
  field :secret, visible: false
  field :email, readonly: true
  field :admin_notes, visible: ->(user) { user.admin? }
  field :salary, readonly: ->(user) { !user.admin? }
end
```

### Field Options

| Option | Type | Description |
|--------|------|-------------|
| `type` | Symbol | Field type (`:text`, `:textarea`, `:number`, `:boolean`, `:date`, `:datetime`, `:select`, `:badge`, `:json`, `:belongs_to`) |
| `visible` | Boolean/Proc | Show or hide the field. Proc receives current user |
| `readonly` | Boolean/Proc | Make field read-only. Proc receives current user |
| `colors` | Hash | Badge color mapping (for `:badge` type) |
| `choices` | Array | Options for `:select` type |

### Controlling Field Visibility per View

```ruby
class UserResource < CommandPost::Resource
  index_fields :id, :name, :email, :role, :created_at
  form_fields :name, :email, :role
  export_fields :id, :name, :email, :role
end
```

## Search

```ruby
class UserResource < CommandPost::Resource
  searchable :name, :email
end
```

If not specified, all `string` and `text` columns are searchable (excluding `*_digest` columns).

### Advanced Search Syntax

CommandPost supports field-specific search queries:

```
email:john@example.com     # Search email field only
name:John                  # Search name field only
role:admin                 # Search role field only
```

Date range search:

```
created_at:2025-01-01..2025-12-31    # Records created in 2025
created_at:2025-06-01..              # Records from June 2025 onwards
created_at:..2025-06-30              # Records before July 2025
```

Search respects field visibility - users cannot search fields they don't have permission to see.

## Filters

```ruby
class UserResource < CommandPost::Resource
  filter :role, type: :select, choices: User.roles.keys
  filter :created_at, type: :date_range
  filter :email_verified, type: :boolean
end
```

Remove auto-inferred filters:

```ruby
remove_filter :some_column
```

### Filter Types

| Type | Description |
|------|-------------|
| `:select` | Dropdown with choices |
| `:date_range` | Date range picker |
| `:boolean` | True/false toggle |

### Auto-Generated Enum Filters

If your model uses Rails enums, CommandPost automatically creates select filters:

```ruby
# app/models/order.rb
class Order < ApplicationRecord
  enum :status, { pending: 0, processing: 1, shipped: 2, delivered: 3 }
end

# No filter definition needed - auto-generated from enum
class OrderResource < CommandPost::Resource
end
```

The filter will display with humanized labels (Pending, Processing, Shipped, Delivered).

## Scopes

Scopes are predefined query filters shown as tabs:

```ruby
class UserResource < CommandPost::Resource
  scope :all, -> { all }, default: true
  scope :admins, -> { where(role: :admin) }
  scope :recent, -> { where("created_at > ?", 7.days.ago) }
  scope :locked, -> { where.not(locked_at: nil) }
end
```

## Soft Delete Support

CommandPost auto-detects models with a `deleted_at` column and provides:

- **Auto-registered scopes**: `with_deleted` and `only_deleted`
- **Auto-registered restore action**: Restores soft-deleted records

```ruby
# If your model has deleted_at column, these are auto-registered:
class PostResource < CommandPost::Resource
  # Auto: scope :with_deleted, -> { unscoped }
  # Auto: scope :only_deleted, -> { only_deleted }
  # Auto: action :restore { |r| r.update!(deleted_at: nil) }
end
```

Works with gems like `paranoia`, `discard`, or custom soft delete implementations.

## Actions

### Record Actions

```ruby
class UserResource < CommandPost::Resource
  action :lock, icon: "lock-closed", confirm: true do |record|
    record.update!(locked_at: Time.current)
  end

  action :send_reset, icon: "envelope" do |record|
    AuthMailer.password_reset(record).deliver_later
  end
end
```

Actions are wrapped in database transactions. Return `false` to rollback:

```ruby
action :process do |record|
  return false unless record.can_process?
  record.process!
end
```

### Bulk Actions

```ruby
class UserResource < CommandPost::Resource
  bulk_action :delete_many do |records|
    records.each(&:destroy!)
  end

  bulk_action :lock_all do |records|
    records.update_all(locked_at: Time.current)
  end
end
```

Bulk actions validate that all selected records are accessible to the current user (respecting tenant scope).

## CRUD Restrictions

```ruby
class AuditLogResource < CommandPost::Resource
  deny_actions :create, :update, :delete
end
```

## Associations

```ruby
class UserResource < CommandPost::Resource
  has_many :licenses, display: :license_key
  has_many :subscriptions
  belongs_to :organization
  has_one :profile
end
```

### Association Preloading

CommandPost automatically preloads associations to prevent N+1 queries:

- `belongs_to` associations shown in index are preloaded
- Related records displayed on show pages are preloaded
- Custom preloads can be added:

```ruby
class OrderResource < CommandPost::Resource
  preload :customer, :line_items, :shipping_address
end
```

### Large Association Handling

For `belongs_to` fields with many options (>100 records), CommandPost automatically uses an autocomplete component instead of a dropdown:

```ruby
class OrderResource < CommandPost::Resource
  field :customer_id, type: :belongs_to,
        association: :customer,
        display: :name
  # Autocomplete is used automatically if Customer has >100 records
end
```

## Menu Configuration

```ruby
class UserResource < CommandPost::Resource
  menu priority: 1, icon: "users", group: "People"
end
```

## Exports

```ruby
class UserResource < CommandPost::Resource
  exports :csv, :json
  export_fields :id, :name, :email, :role, :created_at
end
```

Exports respect:
- Tenant scoping (if configured)
- Field visibility (users only see fields they have permission to view)
- Current filters and search query

## Policies

```ruby
class UserResource < CommandPost::Resource
  policy do
    allow :read, :update
    deny :delete, if: ->(record) { record.admin? }
  end
end
```

See [Authentication & Authorization](authentication.md) for details.

## Component Overrides

```ruby
class UserResource < CommandPost::Resource
  component :table, CustomUserTableComponent
end
```
