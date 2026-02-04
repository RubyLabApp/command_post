# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

CommandPost is a Rails Engine gem that provides a convention-over-configuration admin panel. It auto-generates CRUD interfaces from ActiveRecord models with minimal setup.

## Development Commands

```bash
# Install dependencies
bundle install

# Run all tests
bundle exec rspec

# Run a single test file
bundle exec rspec spec/lib/command_post/resource_spec.rb

# Run a specific test by line number
bundle exec rspec spec/lib/command_post/resource_spec.rb:42

# Run tests with coverage report (outputs to coverage/)
bundle exec rspec  # SimpleCov runs automatically

# Run Rubocop linter
bundle exec rubocop

# Auto-fix Rubocop offenses
bundle exec rubocop -A

# Check Ruby version (should match .ruby-version)
ruby -v
```

## Architecture

### Rails Engine Structure

This is a mountable Rails Engine (`isolate_namespace CommandPost`). Host apps mount it at a path like `/admin`:

```ruby
# Host app's config/routes.rb
mount CommandPost::Engine, at: "/admin"
```

### Core Domain Classes (lib/command_post/)

- **Resource** - Base class for admin resources. Subclasses define field overrides, filters, scopes, actions, and menu options. Auto-registers with ResourceRegistry on inheritance.
- **ResourceRegistry** - Singleton registry of all Resource subclasses. Resources self-register via `inherited` hook.
- **FieldInferrer** - Introspects ActiveRecord models to generate Field objects from database columns.
- **Field** - Value object representing a displayable/editable field with type, visibility, and readonly options.
- **Dashboard** - Base class for dashboard definitions with metrics, charts, and recent record listings.
- **Policy** - DSL for per-resource authorization rules (allow/deny actions with conditions).
- **Configuration** - Global settings (title, auth, theme, pagination). Access via `CommandPost.configuration`.

### Resource Auto-Discovery

Resources are placed in `app/command_post/` in the host app. The engine eager-loads this directory after Rails initialization (see `engine.rb`). Resources auto-register when their class is loaded via the `inherited` callback in Resource.

### Controllers (app/controllers/command_post/)

- **ResourcesController** - Handles all CRUD operations for any registered resource. Uses dynamic routing (`:resource_name` param) to look up the correct Resource class.
- **DashboardController** - Renders the configured Dashboard class.
- **SearchController** - Global search across all searchable resources.
- **ExportsController** - CSV/JSON export for resources.

### ViewComponents (app/components/command_post/)

Uses ViewComponent gem. Components are in `layout/` (shell, sidebar, navbar) and `dashboard/` (metric cards, recent tables).

### Configuration Classes (lib/command_post/configuration/)

- **Theme** - Tailwind CSS class customization for every UI element.
- **Components** - Override default ViewComponent classes with custom implementations.

### Authorization System

- **Policy** - Per-resource authorization with `allow`/`deny` DSL for CRUD and custom actions.
- Controllers check `@resource_class._policy_block` and call `Policy#allowed?`.
- Field-level visibility/readonly via `field.visible?(user)` and `field.readonly?(user)`.

### Audit Logging

- Enable with `config.audit_enabled = true`.
- `AuditLog.log(event)` stores entries with user, action, resource, record_id, changes, ip_address, timestamp.
- View audit log at `/admin/audit`.

### Multi-Tenant Support

- Configure with `config.tenant_scope { |scope| scope.where(org_id: Current.org.id) }`.
- Applied automatically to all resource queries via `base_scope`.

### Soft Delete Support

- Auto-detects `deleted_at` column on models.
- Auto-registers `with_deleted`, `only_deleted` scopes and `restore` action.

## Testing

Tests use a dummy Rails app at `spec/dummy/`. The dummy app has test models (User, License) and corresponding resources.

**All tests must follow [BetterSpecs](https://www.betterspecs.org/) guidelines:**
- Use `describe` for methods, `context` for conditions
- Use `subject` and `let` for setup
- One expectation per test when possible
- Use meaningful test descriptions

```ruby
# spec/rails_helper.rb loads the dummy app
require_relative "dummy/config/environment"
```

Each test resets configuration and registry:
```ruby
config.before(:each) do
  CommandPost.reset_configuration!
  CommandPost::ResourceRegistry.reset!
end
```

## Key Patterns

### Resource DSL

Resources use class-level DSL methods that modify `class_attribute` values:
```ruby
class UserResource < CommandPost::Resource
  field :status, type: :badge        # field_overrides
  searchable :name, :email           # _searchable_columns
  filter :role, type: :select        # defined_filters
  scope :active, -> { where(active: true) }  # defined_scopes
  index_fields :id, :name, :email    # index_field_names
  menu priority: 1, group: "Users"   # menu_options
end
```

### Model Inference

Resource class name maps to model: `UserResource` → `User` model (strips "Resource" suffix, constantizes).

### Theme Customization

All UI classes are configurable via `CommandPost.configure { |c| c.theme { |t| ... } }`. Theme properties return Tailwind CSS classes.
