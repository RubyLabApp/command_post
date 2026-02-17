# Upgrading to IronAdmin 0.5.0

## Namespaced Resources and Dashboards

Version 0.5.0 introduces namespaced directory structure for resources and dashboards. Resource classes now live under `IronAdmin::Resources` and dashboard classes under `IronAdmin::Dashboards`. This prevents namespace pollution in host applications and provides better organization.

### Directory structure changes

**Before (0.4.x):**

```
app/iron_admin/
  user_resource.rb
  product_resource.rb
  admin_dashboard.rb
```

**After (0.5.0):**

```
app/iron_admin/
  resources/
    user_resource.rb
    product_resource.rb
  dashboards/
    admin_dashboard.rb
```

### Step-by-step migration

#### 1. Create the new directories

```bash
mkdir -p app/iron_admin/resources
mkdir -p app/iron_admin/dashboards
```

#### 2. Move resource files

Move all `*_resource.rb` files into `app/iron_admin/resources/`:

```bash
mv app/iron_admin/*_resource.rb app/iron_admin/resources/
```

#### 3. Move dashboard files

Move all `*_dashboard.rb` files into `app/iron_admin/dashboards/`:

```bash
mv app/iron_admin/*_dashboard.rb app/iron_admin/dashboards/
```

#### 4. Update resource class definitions

Wrap each resource class in the `IronAdmin::Resources` module:

```ruby
# Before (app/iron_admin/user_resource.rb)
class UserResource < IronAdmin::Resource
  # ...
end

# After (app/iron_admin/resources/user_resource.rb)
module IronAdmin
  module Resources
    class UserResource < IronAdmin::Resource
      # ...
    end
  end
end
```

#### 5. Update dashboard class definitions

Wrap each dashboard class in the `IronAdmin::Dashboards` module:

```ruby
# Before (app/iron_admin/admin_dashboard.rb)
class AdminDashboard < IronAdmin::Dashboard
  # ...
end

# After (app/iron_admin/dashboards/admin_dashboard.rb)
module IronAdmin
  module Dashboards
    class AdminDashboard < IronAdmin::Dashboard
      # ...
    end
  end
end
```

#### 6. Update any direct class references

If your application code references resource or dashboard classes directly, update the references:

```ruby
# Before
UserResource
AdminDashboard

# After
IronAdmin::Resources::UserResource
IronAdmin::Dashboards::AdminDashboard
```

#### 7. Delete old files

After verifying the new structure works, remove any leftover files from `app/iron_admin/` root:

```bash
# Only delete resource/dashboard files, keep the directory and any other files
rm -f app/iron_admin/*_resource.rb
rm -f app/iron_admin/*_dashboard.rb
```

### What does NOT change

- **Routes** -- No changes needed. The engine mount point and all URL paths remain the same.
- **Configuration** -- `IronAdmin.configure` blocks work exactly as before.
- **Initializers** -- `config/initializers/iron_admin.rb` requires no changes.
- **Resource DSL** -- All DSL methods (`field`, `searchable`, `filter`, `scope`, `action`, `menu`, etc.) work identically.
- **Model inference** -- `IronAdmin::Resources::UserResource` still maps to the `User` model automatically.
- **ResourceRegistry lookups** -- Resources are still registered and looked up by model name (e.g., `"users"`), so controllers and routes work without changes.

### New projects

If you run `rails generate iron_admin:install` or `rails generate iron_admin:resource User` on version 0.5.0, the generators automatically create files in the new namespaced structure. No manual migration is needed for new projects.
