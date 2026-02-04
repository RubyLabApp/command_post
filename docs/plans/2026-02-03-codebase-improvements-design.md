# CommandPost Codebase Improvements Design

> **Goal:** Address critical issues, improve robustness, and add expected admin panel features.

## Current State

- 95.91% test coverage (580 examples)
- 0 Rubocop offenses
- Comprehensive ViewComponent library
- Documentation complete

## Issues Identified

### Critical (Security/Performance)

#### 1. Authorization System Not Functional

**Problem:** The Policy system exists but is never actually invoked.

**Current state:**
```ruby
# lib/command_post/policy.rb - exists but unused
class Policy
  def self.allowed?(user, record = nil)
    new.allowed?(user, record)
  end
end

# lib/command_post/field.rb - methods exist but never called
def visible?(user)
  evaluate(@visible, user)
end

def readonly?(user)
  evaluate(@readonly, user)
end
```

**What's missing:**
- `ResourcesController` only checks `@resource_class.action_allowed?` (global), not Policy
- Components never call `field.visible?` or `field.readonly?`
- No user context passed to authorization checks
- Custom actions and bulk actions have no authorization

**Fix:**
1. Integrate Policy checks into ResourcesController before_actions
2. Pass user to field visibility/readonly checks in components
3. Add authorization checks to execute_action and execute_bulk_action

#### 2. N+1 Query Problem

**Problem:** Index views generate N+1 queries for associations.

**Location:** `resources_controller.rb:8-16`

**Current:**
```ruby
def index
  scope = apply_scopes(apply_filters(@resource_class.model.all))
  # No includes/preload for associations
end
```

**Fix:**
1. Add `preload_associations` class method to Resource
2. Auto-detect belongs_to fields and include them
3. Apply `.includes()` before pagination

#### 3. BelongsTo Loads All Records

**Problem:** Form selects load entire associated table into memory.

**Location:** `belongs_to_component.rb:21-25`

**Current:**
```ruby
def options
  association_class.all.map { |r| [r.public_send(display_method), r.id] }
end
```

**Fix:**
1. Add pagination/limit (default 100)
2. Add search/autocomplete for large tables
3. Add `options_limit` and `options_scope` configuration

### High Priority (Robustness)

#### 4. Export Field Access Without Safeguards

**Problem:** `public_send` called without verifying field exists.

**Location:** `exports_controller.rb:18, 44`

**Fix:**
1. Add `respond_to?` check before `public_send`
2. Add type coercion for CSV (dates, booleans)
3. Return empty string or "[Error]" for missing fields

#### 5. Actions Without Error Handling

**Problem:** Action blocks have no transaction or error handling.

**Location:** `resources_controller.rb:65-78`

**Current:**
```ruby
action[:block].call(@record)
emit_event(params[:action_name], @record)
redirect_to ...
```

**Fix:**
1. Wrap in transaction
2. Rescue exceptions and render error
3. Support return values from action blocks

### Medium Priority (Missing Tests)

#### 6. Authorization Not Tested

**Missing:**
- Test that Policy.allowed? is called
- Test that field visibility is enforced
- Test that readonly fields cannot be modified
- Test custom action authorization

#### 7. Export Edge Cases Not Tested

**Missing:**
- Export with belongs_to associations
- Export with nil values
- CSV special character escaping
- Large dataset exports

#### 8. Filter Edge Cases Not Tested

**Missing:**
- Invalid date in date range filter
- Multiple filters combined
- Filter with custom scope returning nil

### Low Priority (Features)

#### 9. Soft Delete Support

Add support for paranoia/discard gems:
- Detect soft delete column (deleted_at)
- Add "include deleted" scope
- Add "restore" action

#### 10. Audit Log

Built-in activity tracking:
- Log all CRUD operations
- Store user, timestamp, changes
- Provide query interface

#### 11. Multi-Tenant Support

Automatic scoping by user/tenant:
- Add `tenant_scope` configuration
- Apply scope automatically to all queries
- Prevent cross-tenant access

#### 12. Search Improvements

- Field-specific search (email:john@example.com)
- Date range in search
- Full-text search integration
- Saved searches

## Implementation Order

### Phase 1: Critical Fixes (Security/Performance)
1. Authorization system integration
2. N+1 query fix
3. BelongsTo pagination

### Phase 2: Robustness
4. Export error handling
5. Action transaction support
6. Missing test coverage

### Phase 3: Features
7. Soft delete support
8. Audit log
9. Multi-tenant support
10. Search improvements

## Files to Modify

### Phase 1
- `app/controllers/command_post/resources_controller.rb`
- `app/components/command_post/form/belongs_to_component.rb`
- `lib/command_post/resource.rb`
- `lib/command_post/policy.rb`

### Phase 2
- `app/controllers/command_post/exports_controller.rb`
- `spec/requests/command_post/resources_spec.rb`
- `spec/requests/command_post/exports_spec.rb`

### Phase 3
- `lib/command_post/configuration.rb`
- `lib/command_post/resource.rb`
- New: `lib/command_post/audit_log.rb`
- New: `app/controllers/command_post/audit_controller.rb`

## Estimated Scope

- Phase 1: ~15 tasks
- Phase 2: ~10 tasks
- Phase 3: ~20 tasks

Total: ~45 tasks
