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

## Badge Colors

Available keys: `:green`, `:red`, `:yellow`, `:blue`, `:indigo`, `:purple`, `:pink`, `:orange`, `:teal`, `:gray`

Add custom colors:

```ruby
CommandPost.configure do |config|
  config.badge_colors[:cyan] = "bg-cyan-100 text-cyan-800"
end
```
