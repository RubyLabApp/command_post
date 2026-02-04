# Components

CommandPost uses ViewComponent for all UI elements. Override any component globally or per-resource.

## Built-in Components

| Component | Purpose |
|-----------|---------|
| `CommandPost::Layout::ShellComponent` | Main layout wrapper |
| `CommandPost::Layout::NavbarComponent` | Top navigation bar |
| `CommandPost::Layout::SidebarComponent` | Left sidebar |
| `CommandPost::Dashboards::MetricCardComponent` | Dashboard metric |
| `CommandPost::Dashboards::RecentTableComponent` | Dashboard recent records |

## Global Overrides

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

```ruby
class UserResource < CommandPost::Resource
  component :table, CustomUserTableComponent
end
```

## Custom Field Renderers

```ruby
CommandPost.configure do |config|
  config.components.fields[:color_picker] = MyColorPickerFieldComponent
  config.components.fields[:rich_text] = MyRichTextFieldComponent
end
```

Then use:

```ruby
class ProductResource < CommandPost::Resource
  field :accent_color, type: :color_picker
end
```

## Creating Custom Components

```ruby
class CustomNavbarComponent < ViewComponent::Base
  def initialize(title:, current_user:)
    @title = title
    @current_user = current_user
  end
end
```

```haml
-# custom_navbar_component.html.haml
%nav.bg-blue-900.text-white.p-4
  .flex.items-center.justify-between
    %h1= @title
    %span= @current_user&.name
```
