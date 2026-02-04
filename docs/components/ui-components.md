# UI Components

Core UI elements for building admin interfaces.

## BadgeComponent

Displays status indicators with colored backgrounds.

```ruby
CommandPost::UI::BadgeComponent.new(
  text: "Active",      # Required: display text
  color: :green,       # Optional: :gray, :green, :red, :yellow, :blue, :indigo, :purple, :pink, :orange, :teal
  size: :md            # Optional: :sm, :md, :lg
)
```

**Example:**

```haml
= render CommandPost::UI::BadgeComponent.new(text: "Published", color: :green)
= render CommandPost::UI::BadgeComponent.new(text: "Draft", color: :yellow, size: :sm)
```

---

## ButtonComponent

Styled buttons with multiple variants and optional icons.

```ruby
CommandPost::UI::ButtonComponent.new(
  text: "Save",            # Optional: button text
  variant: :primary,       # Optional: :primary, :secondary, :danger, :ghost
  size: :md,               # Optional: :sm, :md, :lg
  icon: "check",           # Optional: Heroicon name
  href: "/path",           # Optional: renders as link instead of button
  method: :post,           # Optional: HTTP method for links (Turbo)
  confirm: "Are you sure?", # Optional: confirmation dialog
  type: :button,           # Optional: :button, :submit
  disabled: false          # Optional: disable the button
)
```

**Examples:**

```haml
-# Primary button
= render CommandPost::UI::ButtonComponent.new(text: "Save Changes", variant: :primary)

-# Danger button with confirmation
= render CommandPost::UI::ButtonComponent.new(
  text: "Delete",
  variant: :danger,
  icon: "trash",
  method: :delete,
  href: resource_path(@record),
  confirm: "This action cannot be undone."
)

-# Icon-only button
= render CommandPost::UI::ButtonComponent.new(icon: "pencil", variant: :ghost, size: :sm)
```

---

## CardComponent

Container with optional header and footer slots.

```ruby
CommandPost::UI::CardComponent.new(
  padding: true,    # Optional: add padding to content area
  shadow: true      # Optional: add shadow
)
```

**Slots:**
- `header` - Card header area
- `footer` - Card footer area

**Example:**

```haml
= render CommandPost::UI::CardComponent.new do |card|
  - card.with_header do
    %h3 User Details

  %p Card content goes here

  - card.with_footer do
    = render CommandPost::UI::ButtonComponent.new(text: "Save", variant: :primary)
```

---

## AlertComponent

Flash messages and notifications.

```ruby
CommandPost::UI::AlertComponent.new(
  message: "Success!",   # Required: alert message
  type: :success,        # Optional: :success, :error, :warning, :info
  dismissible: true      # Optional: show close button
)
```

**Example:**

```haml
= render CommandPost::UI::AlertComponent.new(
  message: "Your changes have been saved.",
  type: :success,
  dismissible: true
)

= render CommandPost::UI::AlertComponent.new(
  message: "Please fix the errors below.",
  type: :error
)
```

---

## ModalComponent

Dialog overlays with customizable content.

```ruby
CommandPost::UI::ModalComponent.new(
  size: :md,           # Optional: :sm, :md, :lg, :xl, :full
  dismissible: true    # Optional: allow closing
)
```

**Slots:**
- `title` - Modal header/title
- `footer` - Modal footer (typically action buttons)

**Example:**

```haml
= render CommandPost::UI::ModalComponent.new(size: :lg) do |modal|
  - modal.with_title do
    Confirm Action

  %p Are you sure you want to proceed?

  - modal.with_footer do
    = render CommandPost::UI::ButtonComponent.new(text: "Cancel", variant: :secondary)
    = render CommandPost::UI::ButtonComponent.new(text: "Confirm", variant: :primary)
```

---

## DropdownComponent

Dropdown menus with trigger and items.

```ruby
CommandPost::UI::DropdownComponent.new(
  align: :right,    # Optional: :left, :right
  width: 48         # Optional: width in Tailwind units (w-48)
)
```

**Slots:**
- `trigger` - The element that opens the dropdown
- `items` - Menu items (renders `ItemComponent`)

**ItemComponent options:**
- `href` - Link URL
- `method` - HTTP method
- `icon` - Heroicon name
- `destructive` - Red styling for destructive actions

**Example:**

```haml
= render CommandPost::UI::DropdownComponent.new(align: :right) do |dropdown|
  - dropdown.with_trigger do
    = render CommandPost::UI::ButtonComponent.new(text: "Actions", icon: "chevron-down")

  - dropdown.with_item(href: edit_path, icon: "pencil") do
    Edit

  - dropdown.with_item(href: delete_path, method: :delete, icon: "trash", destructive: true) do
    Delete
```

---

## TooltipComponent

Hover tooltips for additional information.

```ruby
CommandPost::UI::TooltipComponent.new(
  text: "Helpful info",   # Required: tooltip text
  position: :top          # Optional: :top, :bottom, :left, :right
)
```

**Example:**

```haml
= render CommandPost::UI::TooltipComponent.new(text: "Click to edit", position: :bottom) do
  = render CommandPost::UI::ButtonComponent.new(icon: "pencil", variant: :ghost)
```

---

## PaginationComponent

Pagination controls using Pagy.

```ruby
CommandPost::UI::PaginationComponent.new(
  pagy: @pagy    # Required: Pagy object
)
```

**Note:** Only renders when there are multiple pages.

**Example:**

```haml
= render CommandPost::UI::PaginationComponent.new(pagy: @pagy)
```

---

## ScopesComponent

Tab-style scope navigation.

```ruby
CommandPost::UI::ScopesComponent.new(
  scopes: scopes,           # Required: array of scope hashes
  current_scope: "all",     # Required: currently active scope
  base_path: "/admin/users", # Required: base URL
  params: {}                # Optional: additional URL params
)
```

**Example:**

```ruby
scopes = [
  { name: :all, label: "All" },
  { name: :active, label: "Active" },
  { name: :archived, label: "Archived" }
]
```

```haml
= render CommandPost::UI::ScopesComponent.new(
  scopes: scopes,
  current_scope: params[:scope] || "all",
  base_path: request.path
)
```

---

## EmptyStateComponent

Placeholder for empty data states.

```ruby
CommandPost::UI::EmptyStateComponent.new(
  title: "No users found",       # Required: main message
  description: "Get started...", # Optional: secondary text
  icon: "users",                 # Optional: Heroicon name
  action_text: "Create User",    # Optional: action button text
  action_href: "/users/new"      # Optional: action button link
)
```

**Example:**

```haml
= render CommandPost::UI::EmptyStateComponent.new(
  title: "No records found",
  description: "Try adjusting your search or filters.",
  icon: "magnifying-glass"
)
```
