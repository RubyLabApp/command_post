# Fields

CommandPost automatically infers field types from your ActiveRecord model's database schema.

## Automatic Inference

| DB Column Type | Field Type |
|----------------|------------|
| `string` | `:text` |
| `text` | `:textarea` |
| `integer`, `float`, `decimal` | `:number` |
| `boolean` | `:boolean` |
| `date` | `:date` |
| `datetime` | `:datetime` |
| `time` | `:time` |
| `json`, `jsonb` | `:json` |
| Enum column | `:select` (with enum values as choices) |
| `belongs_to` association | `:belongs_to` |

## Overriding Fields

```ruby
class UserResource < CommandPost::Resource
  field :status, type: :badge, colors: {
    active: :green,
    suspended: :red,
    pending: :yellow
  }
end
```

Overrides merge with inferred fields. You only need to specify the fields you want to change.

## Field Properties

| Property | Type | Description |
|----------|------|-------------|
| `name` | Symbol | Column name |
| `type` | Symbol | Field type |
| `visible` | Boolean/Proc | Whether the field is shown. Proc receives `(current_user)` |
| `readonly` | Boolean/Proc | Whether the field is editable. Proc receives `(current_user)` |

## Dynamic Visibility and Readonly

```ruby
class SalaryResource < CommandPost::Resource
  field :amount, visible: ->(user) { user.admin? || user.hr? }
  field :department, readonly: ->(user) { !user.admin? }
end
```

Visibility and readonly rules are enforced across:
- Index table columns
- Show page fields
- Form fields (readonly fields are disabled)
- CSV/JSON exports
- Search queries

## Badge Colors

Available keys: `:green`, `:red`, `:yellow`, `:blue`, `:indigo`, `:purple`, `:pink`, `:orange`, `:teal`, `:gray`

Add custom colors:

```ruby
CommandPost.configure do |config|
  config.badge_colors[:cyan] = "bg-cyan-100 text-cyan-800"
end
```

### Default Badge Colors for Common Status Values

CommandPost automatically assigns colors to common status values without configuration:

| Status Value | Color |
|--------------|-------|
| `active`, `published`, `enabled`, `approved`, `success` | Green |
| `pending`, `draft`, `waiting`, `processing` | Yellow |
| `completed`, `done`, `finished` | Blue |
| `failed`, `error`, `rejected`, `cancelled`, `disabled` | Red |
| `inactive`, `archived`, `suspended` | Gray |
| `admin`, `superuser`, `owner` | Purple |
| `user`, `member`, `subscriber` | Blue |
| `guest`, `visitor` | Gray |

Example:

```ruby
class OrderResource < CommandPost::Resource
  # No colors needed - auto-detected from value
  field :status, type: :badge
end

# Order with status "pending" will show a yellow badge
# Order with status "completed" will show a blue badge
```

Override auto-detected colors by providing explicit colors:

```ruby
field :status, type: :badge, colors: {
  pending: :orange,    # Override default yellow
  completed: :green    # Override default blue
}
```
