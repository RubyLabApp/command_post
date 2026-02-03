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

## Policies

```ruby
class UserResource < CommandPost::Resource
  policy do
    allow :read, :update
    deny :delete, if: ->(record) { record.admin? }
  end
end
```

## Component Overrides

```ruby
class UserResource < CommandPost::Resource
  component :table, CustomUserTableComponent
end
```
