# Extending the Engine

CommandPost is designed to be extended at every level.

## Extension Points

1. **Configuration blocks** - Authentication, current user, audit logging
2. **Resource DSL** - Fields, filters, scopes, actions, policies
3. **Component overrides** - Replace any UI component
4. **Custom field types** - Register new field renderers
5. **Dashboard customization** - Metrics, charts, recent records
6. **Theme system** - 40+ CSS class properties
7. **Route mounting** - Mount at any path

## Custom Resources with Business Logic

```ruby
class SubscriptionResource < CommandPost::Resource
  action :cancel, icon: "x-circle", confirm: true do |record|
    Billing::CancelSubscriptionService.call(subscription: record)
  end

  bulk_action :pause_all do |records|
    records.each { |sub| sub.update!(status: :paused) }
  end
end
```

## Subclassing the Base Controller

```ruby
# config/initializers/command_post.rb
Rails.application.config.to_prepare do
  CommandPost::ApplicationController.class_eval do
    before_action :set_timezone

    private

    def set_timezone
      Time.zone = command_post_current_user&.timezone || "UTC"
    end
  end
end
```

## Adding Custom Routes

```ruby
mount CommandPost::Engine => "/admin"

namespace :admin do
  get "reports/revenue", to: "reports#revenue"
end
```

## Overriding Views

Place overrides following the engine's view path:

```
app/views/command_post/
  resources/
    index.html.haml
  dashboard/
    index.html.haml
  layouts/
    application.html.haml
```

Rails uses your app's views over the engine's views automatically.

## Extending the Resource Class

```ruby
class ApplicationResource < CommandPost::Resource
  exports :csv, :json

  def self.inherited(subclass)
    super
    subclass.menu group: "General" unless subclass.menu_options[:group]
  end
end

class UserResource < ApplicationResource
  menu group: "People"
end
```

## Per-Environment Configuration

```ruby
CommandPost.configure do |config|
  config.title = "My App Admin"
  config.title += " [STAGING]" if Rails.env.staging?
  config.per_page = Rails.env.development? ? 10 : 25
end
```

## Testing Resources

```ruby
RSpec.describe UserResource do
  it "maps to User model" do
    expect(UserResource.model).to eq(User)
  end

  it "resolves fields from schema" do
    fields = UserResource.resolved_fields
    expect(fields.map(&:name)).to include(:email, :name)
  end
end
```
