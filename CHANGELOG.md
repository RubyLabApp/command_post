# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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
