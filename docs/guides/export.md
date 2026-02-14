# Export

IronAdmin provides built-in CSV and JSON export.

## Enabling Export

Enabled by default with CSV and JSON:

```ruby
class UserResource < IronAdmin::Resource
  exports :csv, :json
end
```

Disable:

```ruby
class SecretResource < IronAdmin::Resource
  exports
end
```

## Custom Export Fields

```ruby
class UserResource < IronAdmin::Resource
  export_fields :id, :name, :email, :role, :created_at
end
```

## Export URL

```
GET /admin/:resource_name/export?format=csv
GET /admin/:resource_name/export?format=json
```

Exports respect current filters and search query.
