# Components

IronAdmin uses [ViewComponent](https://viewcomponent.org/) for all UI elements. This guide covers how to override and extend components.

For the complete component reference, see the [Components Library](../components/README.md).

## Built-in Components

### Layout Components

| Component | Purpose |
|-----------|---------|
| `IronAdmin::Layout::ShellComponent` | Main layout wrapper |
| `IronAdmin::Layout::NavbarComponent` | Top navigation bar |
| `IronAdmin::Layout::SidebarComponent` | Left sidebar navigation |

### UI Components

| Component | Purpose |
|-----------|---------|
| `IronAdmin::UI::BadgeComponent` | Status badges |
| `IronAdmin::UI::ButtonComponent` | Styled buttons |
| `IronAdmin::UI::CardComponent` | Card containers |
| `IronAdmin::UI::AlertComponent` | Flash messages |
| `IronAdmin::UI::ModalComponent` | Dialog overlays |
| `IronAdmin::UI::DropdownComponent` | Dropdown menus |
| `IronAdmin::UI::TooltipComponent` | Hover tooltips |
| `IronAdmin::UI::PaginationComponent` | Pagination controls |
| `IronAdmin::UI::ScopesComponent` | Scope tabs |
| `IronAdmin::UI::EmptyStateComponent` | Empty state placeholders |

### Form Components

| Component | Purpose |
|-----------|---------|
| `IronAdmin::Form::TextInputComponent` | Text inputs |
| `IronAdmin::Form::SelectComponent` | Select dropdowns |
| `IronAdmin::Form::CheckboxComponent` | Checkboxes |
| `IronAdmin::Form::TextareaComponent` | Multi-line text |
| `IronAdmin::Form::DatePickerComponent` | Date/time inputs |
| `IronAdmin::Form::BelongsToComponent` | Association selects |
| `IronAdmin::Form::FieldWrapperComponent` | Field wrapper with label/errors |

### Filter Components

| Component | Purpose |
|-----------|---------|
| `IronAdmin::Filters::SearchComponent` | Search input |
| `IronAdmin::Filters::SelectFilterComponent` | Dropdown filter |
| `IronAdmin::Filters::DateRangeComponent` | Date range filter |
| `IronAdmin::Filters::BarComponent` | Filter container |

### Resource Components

| Component | Purpose |
|-----------|---------|
| `IronAdmin::Resources::DataTableComponent` | Sortable data table |
| `IronAdmin::Resources::ShowFieldComponent` | Field display |
| `IronAdmin::Resources::ActionsComponent` | Record actions |
| `IronAdmin::Resources::BreadcrumbComponent` | Breadcrumb navigation |
| `IronAdmin::Resources::BulkActionsComponent` | Bulk selection actions |
| `IronAdmin::Resources::RelatedListComponent` | Has-many associations |

### Dashboard Components

| Component | Purpose |
|-----------|---------|
| `IronAdmin::Dashboards::ChartComponent` | Charts (line, bar, pie) |
| `IronAdmin::Dashboards::StatsGridComponent` | Metric stats grid |
| `IronAdmin::Dashboards::ActivityFeedComponent` | Activity timeline |
| `IronAdmin::Dashboards::QuickLinksComponent` | Quick action links |
| `IronAdmin::Dashboards::MetricCardComponent` | Single metric card |
| `IronAdmin::Dashboards::RecentTableComponent` | Recent records table |

## Global Overrides

Override components globally in your initializer:

```ruby
IronAdmin.configure do |config|
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
class UserResource < IronAdmin::Resource
  component :table, CustomUserTableComponent
end
```

## Custom Field Renderers

Register custom field type components:

```ruby
IronAdmin.configure do |config|
  config.components.fields[:color_picker] = MyColorPickerFieldComponent
  config.components.fields[:rich_text] = MyRichTextFieldComponent
end
```

Then use in resources:

```ruby
class ProductResource < IronAdmin::Resource
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
    IronAdmin.configuration.theme
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
