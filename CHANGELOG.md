# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.2.0] - 2026-02-07

First public release.

### Added

- **Core Features**
  - Zero-configuration CRUD operations from database schema
  - Resource DSL for customizing fields, filters, scopes, and actions
  - Dashboard builder with metrics, charts, and recent records widgets
  - Theme system with fully customizable Tailwind CSS classes
  - Built-in policy system for authorization
  - Global search across all resources
  - CSV and JSON export functionality

- **Authorization System**
  - Policy-based authorization integrated into ResourcesController
  - Field visibility enforcement (`field.visible?(user)`)
  - Field readonly enforcement in form components (`field.readonly?(user)`)
  - Custom action and bulk action authorization

- **Performance Improvements**
  - Automatic association preloading to prevent N+1 queries
  - BelongsTo component pagination (default limit 100)
  - BelongsTo autocomplete component for large associations

- **Soft Delete Support**
  - Auto-detection of `deleted_at` column
  - Auto-registered `with_deleted` and `only_deleted` scopes
  - Auto-registered `restore` action

- **Audit Logging**
  - Built-in audit log with `AuditLog.log(event)`
  - Audit log viewer at `/admin/audit`
  - Enable with `config.audit_enabled = true`
  - Optional database persistence with `config.audit_storage = :database`
  - 100% optional - works without any configuration
  - Graceful fallback to memory if database table doesn't exist

- **Multi-Tenant Support**
  - `config.tenant_scope` for automatic query scoping
  - Applied to all resource queries (index, show, edit, update, destroy, exports, bulk actions)

- **Advanced Search**
  - Field-specific search syntax (`email:john@example.com`)
  - Date range search (`created_at:2025-01-01..2025-12-31`)
  - Search respects field visibility (security)

- **Convention-over-Configuration Enhancements**
  - Auto-generate select filters for model enums
  - Default badge colors for common status values (active, pending, completed, etc.)
  - Policy instances cached at Resource class level for performance

- **Comprehensive ViewComponent Library**
  - UI: Badge, Button, Card, Alert, Modal, Dropdown, Tooltip, Pagination, Scopes, EmptyState
  - Form: TextInput, Select, Checkbox, Textarea, DatePicker, BelongsTo, FieldWrapper
  - Filter: Search, SelectFilter, DateRange, BarComponent
  - Resource: DataTable, ShowField, Actions, Breadcrumb, BulkActions, RelatedList
  - Dashboard: Chart, StatsGrid, ActivityFeed, QuickLinks, MetricCard, RecentTable

### Fixed

- Export error handling for missing fields and type coercion
- Custom actions wrapped in database transactions with proper error handling
- Date filter parsing for invalid dates
- Filter bypass attempts via URL manipulation
- **Security**: Field visibility now enforced in exports (CSV/JSON)
- **Security**: Field visibility now enforced in search queries
- **Security**: `execute_action` error handling order (validates action before finding record)
- **Security**: Export controller now respects tenant scoping
- **Security**: Show action now requires authorization (`:read` permission)
- **Security**: Bulk actions validate all selected records are accessible in tenant scope
- **Security**: Policy supports bidirectional action aliases (`:show`/`:index` ↔ `:read`)
- AuditEntry.table_exists? now handles database errors gracefully

### Changed

- 997 tests with 95%+ coverage
- 100% YARD documentation coverage
- Refactored form components to use shared `FormInputBehavior` concern
- Policy instances now cached at Resource class level
- Field visibility filtering applied consistently in index, show, forms, exports, and search

[Unreleased]: https://github.com/RubyLabApp/command_post/compare/v0.2.0...HEAD
[0.2.0]: https://github.com/RubyLabApp/command_post/releases/tag/v0.2.0
