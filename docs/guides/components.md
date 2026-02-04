# Components

CommandPost uses [ViewComponent](https://viewcomponent.org/) for all UI elements. This guide covers how to override and extend components.

For the complete component reference, see the [Components Library](../components/README.md).

## Built-in Components

### Layout Components

| Component | Purpose |
|-----------|---------|
| `CommandPost::Layout::ShellComponent` | Main layout wrapper |
| `CommandPost::Layout::NavbarComponent` | Top navigation bar |
| `CommandPost::Layout::SidebarComponent` | Left sidebar navigation |

### UI Components

| Component | Purpose |
|-----------|---------|
| `CommandPost::UI::BadgeComponent` | Status badges |
| `CommandPost::UI::ButtonComponent` | Styled buttons |
| `CommandPost::UI::CardComponent` | Card containers |
| `CommandPost::UI::AlertComponent` | Flash messages |
| `CommandPost::UI::ModalComponent` | Dialog overlays |
| `CommandPost::UI::DropdownComponent` | Dropdown menus |
| `CommandPost::UI::TooltipComponent` | Hover tooltips |
| `CommandPost::UI::PaginationComponent` | Pagination controls |
| `CommandPost::UI::ScopesComponent` | Scope tabs |
| `CommandPost::UI::EmptyStateComponent` | Empty state placeholders |

### Form Components

| Component | Purpose |
|-----------|---------|
| `CommandPost::Form::TextInputComponent` | Text inputs |
| `CommandPost::Form::SelectComponent` | Select dropdowns |
| `CommandPost::Form::CheckboxComponent` | Checkboxes |
| `CommandPost::Form::TextareaComponent` | Multi-line text |
| `CommandPost::Form::DatePickerComponent` | Date/time inputs |
| `CommandPost::Form::BelongsToComponent` | Association selects |
| `CommandPost::Form::FieldWrapperComponent` | Field wrapper with label/errors |

### Filter Components

| Component | Purpose |
|-----------|---------|
| `CommandPost::Filters::SearchComponent` | Search input |
| `CommandPost::Filters::SelectFilterComponent` | Dropdown filter |
| `CommandPost::Filters::DateRangeComponent` | Date range filter |
| `CommandPost::Filters::BarComponent` | Filter container |

### Resource Components

| Component | Purpose |
|-----------|---------|
| `CommandPost::Resources::DataTableComponent` | Sortable data table |
| `CommandPost::Resources::ShowFieldComponent` | Field display |
| `CommandPost::Resources::ActionsComponent` | Record actions |
| `CommandPost::Resources::BreadcrumbComponent` | Breadcrumb navigation |
| `CommandPost::Resources::BulkActionsComponent` | Bulk selection actions |
| `CommandPost::Resources::RelatedListComponent` | Has-many associations |

### Dashboard Components

| Component | Purpose |
|-----------|---------|
| `CommandPost::Dashboards::ChartComponent` | Charts (line, bar, pie) |
| `CommandPost::Dashboards::StatsGridComponent` | Metric stats grid |
| `CommandPost::Dashboards::ActivityFeedComponent` | Activity timeline |
| `CommandPost::Dashboards::QuickLinksComponent` | Quick action links |
| `CommandPost::Dashboards::MetricCardComponent` | Single metric card |
| `CommandPost::Dashboards::RecentTableComponent` | Recent records table |

## Global Overrides

Override components globally in your initializer:

```ruby
CommandPost.configure do |config|
  config.components.navbar = MyCustomNavbarComponent
  config.components.sidebar = MyCustomSidebarComponent
  config.components.shell = MyCustomShellComponent
  config.components.table = MyCustomTableComponent
  config.components.form = MyCustomFormComponent
  config.components.filter_bar = MyCustomFilterBarComponent
  config.components.search = MyCustomSearchComponent
end
```

## Per-Resource Overrides

Override components for a specific resource:

```ruby
class UserResource < CommandPost::Resource
  component :table, CustomUserTableComponent
end
```

## Custom Field Renderers

Register custom field type components:

```ruby
CommandPost.configure do |config|
  config.components.fields[:color_picker] = MyColorPickerFieldComponent
  config.components.fields[:rich_text] = MyRichTextFieldComponent
end
```

Then use in resources:

```ruby
class ProductResource < CommandPost::Resource
  field :accent_color, type: :color_picker
end
```

## Creating Custom Components

Custom components should inherit from `ViewComponent::Base`:

```ruby
class CustomNavbarComponent < ViewComponent::Base
  def initialize(title:, current_user:)
    @title = title
    @current_user = current_user
  end

  def theme
    CommandPost.configuration.theme
  end
end
```

```haml
-# custom_navbar_component.html.haml
%nav{ class: "#{theme.navbar_bg} p-4" }
  .flex.items-center.justify-between
    %h1{ class: theme.body_text }= @title
    %span{ class: theme.muted_text }= @current_user&.name
```

## Theme Integration

Access theme properties in components via the `theme` method:

```ruby
def card_classes
  "#{theme.card_bg} #{theme.card_border} #{theme.border_radius} #{theme.card_shadow}"
end
```

## Component Documentation

For detailed documentation on each component including all options and examples:

- [UI Components](../components/ui-components.md)
- [Form Components](../components/form-components.md)
- [Filter Components](../components/filter-components.md)
- [Resource Components](../components/resource-components.md)
- [Dashboard Components](../components/dashboard-components.md)
