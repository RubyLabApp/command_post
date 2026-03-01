# frozen_string_literal: true

module IronAdmin
  module Resources
    class WidgetResource < IronAdmin::Resource
      field :status, type: :radio, choices: %w[active inactive draft]
      field :permissions, type: :boolean_group, choices: %w[read write delete admin]
      field :image_url, type: :external_image, height: "h-32"
      field :completion, type: :progress_bar, color: "bg-green-500"
      field :config_json, type: :key_value
      field :source_code, type: :code, language: "ruby", rows: 12
      field :secret_token, type: :hidden

      searchable :name
      menu icon: "cube", group: "Testing"
    end
  end
end
