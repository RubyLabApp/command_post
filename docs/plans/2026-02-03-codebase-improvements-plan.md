# CommandPost Codebase Improvements Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Fix critical security/performance issues, improve robustness, and add expected admin panel features.

**Architecture:** Three-phase implementation - critical fixes first, then robustness improvements, then feature additions.

**Tech Stack:** Ruby on Rails Engine, ViewComponent, RSpec, SimpleCov

---

## Phase 1: Critical Fixes (Security/Performance)

### Task 1: Add Policy Integration to ResourcesController

**Files:**
- Modify: `app/controllers/command_post/resources_controller.rb`

**Step 1: Read current authorization implementation**

Review current `check_action_allowed` method at line 100-107.

**Step 2: Write failing test for policy-based authorization**

Create test in `spec/requests/command_post/resources_spec.rb`:
- Test that policy deny blocks return 403 forbidden
- Test context: UserResource with policy that denies destroy

**Step 3: Run test to verify it fails**

Run: `bundle exec rspec spec/requests/command_post/resources_spec.rb -e "authorization"`

**Step 4: Implement policy check in controller**

Update check_action_allowed to:
- Check global action permission (existing)
- Check policy if defined (new)
- Pass user context to policy

**Step 5: Run test to verify it passes**

**Step 6: Commit**

Message: "feat: Integrate Policy checks into ResourcesController authorization"

---

### Task 2: Add Field Visibility Enforcement

**Files:**
- Modify: `app/components/command_post/resources/data_table_component.rb`
- Modify: `app/components/command_post/resources/show_field_component.rb`

**Step 1: Write failing test for field visibility**

Test that invisible fields are not rendered in DataTableComponent.

**Step 2: Run test to verify it fails**

**Step 3: Implement visibility check**

Add `visible_fields` method that filters fields by `f.visible?(current_user)`.

**Step 4: Run test to verify it passes**

**Step 5: Apply same pattern to ShowFieldComponent**

**Step 6: Commit**

Message: "feat: Enforce field visibility in table and show components"

---

### Task 3: Add Field Readonly Enforcement in Forms

**Files:**
- Modify: `app/components/command_post/form/text_input_component.rb`
- Modify: `app/components/command_post/form/select_component.rb`
- Modify: `app/components/command_post/form/textarea_component.rb`
- Modify: `app/components/command_post/form/checkbox_component.rb`

**Step 1: Write failing test for readonly fields**

Test that readonly fields render with disabled attribute.

**Step 2: Run test to verify it fails**

**Step 3: Implement readonly check**

Add disabled attribute when `@field&.readonly?(current_user)` is true.

**Step 4: Run tests**

**Step 5: Apply to all form components**

**Step 6: Commit**

Message: "feat: Enforce readonly fields in form components"

---

### Task 4: Add Authorization for Custom Actions

**Files:**
- Modify: `app/controllers/command_post/resources_controller.rb`

**Step 1: Write failing test for custom action authorization**

Test that denied custom actions return 403.

**Step 2: Run test to verify it fails**

**Step 3: Implement action authorization**

Add `action_authorized?` method checking policy for action permission.

**Step 4: Run test to verify it passes**

**Step 5: Apply same pattern to bulk actions**

**Step 6: Commit**

Message: "feat: Add authorization for custom and bulk actions"

---

### Task 5: Fix N+1 Query - Add Association Preloading

**Files:**
- Modify: `lib/command_post/resource.rb`
- Modify: `app/controllers/command_post/resources_controller.rb`

**Step 1: Write test for preloading**

Test query count stays constant regardless of record count.

**Step 2: Add preload_associations class method to Resource**

Auto-detect belongs_to fields and return association names.

**Step 3: Apply preloading in controller**

Add `.includes(*@resource_class.preload_associations)` to index scope.

**Step 4: Run tests**

**Step 5: Commit**

Message: "perf: Add automatic association preloading to prevent N+1 queries"

---

### Task 6: Fix BelongsTo Component - Add Pagination

**Files:**
- Modify: `app/components/command_post/form/belongs_to_component.rb`
- Modify: `app/components/command_post/form/belongs_to_component.html.haml`

**Step 1: Write test for options limit**

Test that options are limited to configured maximum.

**Step 2: Run test to verify it fails**

**Step 3: Implement options limit**

Add DEFAULT_OPTIONS_LIMIT = 100, apply limit to options query.

**Step 4: Update template to show hint when truncated**

**Step 5: Run tests**

**Step 6: Commit**

Message: "perf: Add pagination limit to BelongsTo component options"

---

### Task 7: Add Autocomplete for Large BelongsTo Associations

**Files:**
- Create: `app/components/command_post/form/belongs_to_autocomplete_component.rb`
- Create: `app/components/command_post/form/belongs_to_autocomplete_component.html.haml`
- Modify: `app/controllers/command_post/resources_controller.rb`

**Step 1: Write test for autocomplete endpoint**

Test JSON response with matching records.

**Step 2: Implement autocomplete endpoint**

Add `autocomplete` action returning JSON array of {id, label}.

**Step 3: Create autocomplete component with Stimulus controller**

**Step 4: Run tests**

**Step 5: Commit**

Message: "feat: Add autocomplete component for large BelongsTo associations"

---

## Phase 2: Robustness Improvements

### Task 8: Add Error Handling to Exports

**Files:**
- Modify: `app/controllers/command_post/exports_controller.rb`

**Step 1: Write failing test for missing field**

Test graceful handling when field doesn't exist.

**Step 2: Run test to verify it fails**

**Step 3: Implement safe field access**

Add `safe_field_value` with respond_to? check and type formatting.

**Step 4: Run tests**

**Step 5: Commit**

Message: "fix: Add error handling and type coercion to exports"

---

### Task 9: Wrap Actions in Transactions

**Files:**
- Modify: `app/controllers/command_post/resources_controller.rb`

**Step 1: Write test for action rollback on error**

Test that changes are rolled back when action raises.

**Step 2: Run test to verify it fails**

**Step 3: Implement transaction wrapper**

Wrap action block in ActiveRecord::Base.transaction with rescue.

**Step 4: Run tests**

**Step 5: Apply same pattern to bulk actions**

**Step 6: Commit**

Message: "fix: Wrap custom actions in transactions with error handling"

---

### Task 10: Add Export Tests for Associations

**Files:**
- Modify: `spec/requests/command_post/exports_spec.rb`

**Step 1: Write test for belongs_to export**

Test that association display value is exported.

**Step 2: Run test**

**Step 3: Fix export to handle associations**

**Step 4: Add test for nil associations**

**Step 5: Commit**

Message: "test: Add export tests for associations and edge cases"

---

### Task 11: Add Filter Edge Case Tests

**Files:**
- Modify: `spec/requests/command_post/resources_spec.rb`

**Step 1: Write test for invalid date filter**

Test that invalid dates don't crash.

**Step 2: Run tests**

**Step 3: Add error handling to date filter parsing**

**Step 4: Commit**

Message: "test: Add filter edge case tests and improve date parsing"

---

### Task 12: Add Authorization Integration Tests

**Files:**
- Modify: `spec/requests/command_post/resources_spec.rb`

**Step 1: Write comprehensive authorization tests**

Test create, update, destroy policy enforcement.

**Step 2: Run tests**

**Step 3: Fix any failures**

**Step 4: Commit**

Message: "test: Add comprehensive authorization integration tests"

---

## Phase 3: New Features

### Task 13: Add Soft Delete Detection

**Files:**
- Modify: `lib/command_post/resource.rb`

**Step 1: Write test for soft delete detection**

Test that models with deleted_at are detected.

**Step 2: Implement soft delete detection**

Add `soft_delete?` class method checking column_names.

**Step 3: Run tests**

**Step 4: Commit**

Message: "feat: Add soft delete detection to Resource"

---

### Task 14: Add "Include Deleted" Scope

**Files:**
- Modify: `lib/command_post/resource.rb`
- Modify: `app/controllers/command_post/resources_controller.rb`

**Step 1: Write test for with_deleted scope**

**Step 2: Auto-register with_deleted scope for soft delete models**

**Step 3: Run tests**

**Step 4: Commit**

Message: "feat: Add with_deleted scope for soft delete models"

---

### Task 15: Add Restore Action for Soft Deleted Records

**Files:**
- Modify: `lib/command_post/resource.rb`
- Modify: `app/controllers/command_post/resources_controller.rb`

**Step 1: Write test for restore action**

**Step 2: Auto-register restore action for soft delete models**

**Step 3: Run tests**

**Step 4: Commit**

Message: "feat: Add restore action for soft deleted records"

---

### Task 16: Create Audit Log Infrastructure

**Files:**
- Create: `lib/command_post/audit_log.rb`
- Create: `lib/generators/command_post/audit_migration_generator.rb`

**Step 1: Design AuditLog module**

Entry class with user, action, resource, record_id, changes, ip_address, timestamp.

**Step 2: Write tests**

**Step 3: Run tests**

**Step 4: Commit**

Message: "feat: Add AuditLog infrastructure"

---

### Task 17: Create Audit Migration Generator

**Files:**
- Create: `lib/generators/command_post/audit_generator.rb`
- Create: `lib/generators/command_post/templates/create_command_post_audit_entries.rb.tt`

**Step 1: Create generator**

**Step 2: Create migration template**

**Step 3: Test generator**

**Step 4: Commit**

Message: "feat: Add audit migration generator"

---

### Task 18: Integrate Audit Log with ResourcesController

**Files:**
- Modify: `app/controllers/command_post/resources_controller.rb`
- Modify: `lib/command_post/configuration.rb`

**Step 1: Add audit configuration option**

**Step 2: Call AuditLog from emit_event**

**Step 3: Write tests**

**Step 4: Commit**

Message: "feat: Integrate AuditLog with ResourcesController"

---

### Task 19: Create Audit Log Viewer

**Files:**
- Create: `app/controllers/command_post/audit_controller.rb`
- Create: `app/views/command_post/audit/index.html.haml`

**Step 1: Create controller**

**Step 2: Create view**

**Step 3: Add route**

**Step 4: Write tests**

**Step 5: Commit**

Message: "feat: Add AuditLog viewer controller and view"

---

### Task 20: Add Multi-Tenant Scope Configuration

**Files:**
- Modify: `lib/command_post/configuration.rb`
- Modify: `lib/command_post/resource.rb`

**Step 1: Add tenant scope configuration**

**Step 2: Write test**

**Step 3: Run test**

**Step 4: Commit**

Message: "feat: Add tenant scope configuration"

---

### Task 21: Apply Tenant Scope to All Queries

**Files:**
- Modify: `app/controllers/command_post/resources_controller.rb`

**Step 1: Write test for tenant scoping in CRUD**

**Step 2: Apply tenant scope in controller base_scope**

**Step 3: Apply to show, edit, update, destroy**

**Step 4: Run tests**

**Step 5: Commit**

Message: "feat: Apply tenant scope to all resource queries"

---

### Task 22: Add Field-Specific Search Syntax

**Files:**
- Modify: `app/controllers/command_post/resources_controller.rb`

**Step 1: Write test for field search**

Test field:value syntax.

**Step 2: Parse field:value syntax**

**Step 3: Run tests**

**Step 4: Commit**

Message: "feat: Add field:value search syntax"

---

### Task 23: Add Date Range Search

**Files:**
- Modify: `app/controllers/command_post/resources_controller.rb`

**Step 1: Write test for date range**

Test field:from..to syntax.

**Step 2: Parse date range syntax**

**Step 3: Run tests**

**Step 4: Commit**

Message: "feat: Add date range search syntax (field:from..to)"

---

### Task 24: Add Saved Searches

**Files:**
- Create: `lib/command_post/saved_search.rb`
- Create: `lib/generators/command_post/saved_searches_generator.rb`

**Step 1: Design SavedSearch model**

**Step 2: Create generator for migration**

**Step 3: Write tests**

**Step 4: Commit**

Message: "feat: Add SavedSearch infrastructure"

---

### Task 25: Add Saved Searches UI

**Files:**
- Create: `app/components/command_post/filters/saved_searches_component.rb`
- Modify: `app/views/command_post/resources/index.html.haml`

**Step 1: Create component**

**Step 2: Add to index view**

**Step 3: Write tests**

**Step 4: Commit**

Message: "feat: Add SavedSearches UI component"

---

### Task 26: Create CSV Import Infrastructure

**Files:**
- Create: `lib/command_post/import.rb`
- Create: `app/controllers/command_post/imports_controller.rb`

**Step 1: Design Import module**

preview, execute, valid? methods.

**Step 2: Create controller**

**Step 3: Write tests**

**Step 4: Commit**

Message: "feat: Add CSV import infrastructure"

---

### Task 27: Add Import Preview View

**Files:**
- Create: `app/views/command_post/imports/new.html.haml`
- Create: `app/views/command_post/imports/preview.html.haml`

**Step 1: Create upload form**

**Step 2: Create preview table**

**Step 3: Add confirmation step**

**Step 4: Write tests**

**Step 5: Commit**

Message: "feat: Add import preview views"

---

### Task 28: Add Import Validation

**Files:**
- Modify: `lib/command_post/import.rb`

**Step 1: Add column mapping validation**

**Step 2: Write tests**

**Step 3: Commit**

Message: "feat: Add import validation with detailed error messages"

---

### Task 29: Add JSON Import Support

**Files:**
- Modify: `lib/command_post/import.rb`
- Modify: `app/controllers/command_post/imports_controller.rb`

**Step 1: Add JSON parsing**

**Step 2: Write tests**

**Step 3: Commit**

Message: "feat: Add JSON import support"

---

### Task 30: Update CLAUDE.md with New Features

**Files:**
- Modify: `CLAUDE.md`

**Step 1: Read current CLAUDE.md**

**Step 2: Add sections for new features**

**Step 3: Commit**

Message: "docs: Update CLAUDE.md with new features"

---

### Task 31: Update User-Facing Documentation

**Files:**
- Modify: `docs/guides/authentication.md`
- Create: `docs/guides/audit-log.md`
- Create: `docs/guides/import-export.md`
- Create: `docs/guides/multi-tenant.md`

**Step 1: Update authentication guide with Policy examples**

**Step 2: Create audit log guide**

**Step 3: Create import/export guide**

**Step 4: Create multi-tenant guide**

**Step 5: Commit**

Message: "docs: Add guides for audit log, import/export, and multi-tenant"

---

### Task 32: Run Full Test Suite and Fix Issues

**Files:**
- Various

**Step 1: Run full test suite**

Run: `bundle exec rspec`

**Step 2: Fix any failures**

**Step 3: Check coverage**

Verify 95%+ coverage

**Step 4: Run Rubocop**

Run: `bundle exec rubocop`

**Step 5: Fix any offenses**

**Step 6: Commit fixes**

Message: "fix: Address test failures and Rubocop offenses"

---

### Task 33: Final Review and Changelog Update

**Files:**
- Modify: `CHANGELOG.md`

**Step 1: Update CHANGELOG with all changes**

Add sections for Added, Fixed, Performance.

**Step 2: Commit**

Message: "docs: Update CHANGELOG with all improvements"

---

## Summary

| Phase | Tasks | Focus |
|-------|-------|-------|
| 1 | 1-7 | Critical security and performance fixes |
| 2 | 8-12 | Robustness and test coverage |
| 3 | 13-33 | New features and documentation |

**Total: 33 tasks**

Each task follows TDD:
1. Write failing test
2. Implement minimal solution
3. Verify tests pass
4. Commit with descriptive message
