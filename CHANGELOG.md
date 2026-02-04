# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- **Authorization System Improvements**
  - Policy-based authorization now integrated into ResourcesController
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

- **Multi-Tenant Support**
  - `config.tenant_scope` for automatic query scoping
  - Applied to all resource queries (index, show, edit, update, destroy)

- **Advanced Search**
  - Field-specific search syntax (`email:john@example.com`)
  - Date range search (`created_at:2025-01-01..2025-12-31`)

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

### Changed

- 841 tests with 96%+ coverage
- 0 Rubocop offenses

## [0.1.0] - 2026-02-03

### Added

- Initial release of CommandPost admin panel engine
- Zero-configuration CRUD operations from database schema
- Resource DSL for customizing fields, filters, scopes, and actions
- Dashboard builder with metrics, charts, and recent records widgets
- Theme system with fully customizable Tailwind CSS classes
- Built-in policy system for authorization
- Global search across all resources
- CSV and JSON export functionality
- ViewComponent-based UI architecture
- Turbo and Stimulus integration for dynamic interactions

### Technical

- Rails Engine with isolated namespace
- Ruby >= 3.2 and Rails >= 7.1 required
- Haml templates for views
- SQLite and PostgreSQL support

[Unreleased]: https://github.com/rubylab/command-post/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/rubylab/command-post/releases/tag/v0.1.0
