module IronAdmin
  module Resources
    class ProjectResource < IronAdmin::Resource
      # Radio — select one of several statuses via radio buttons
      field :status, type: :radio, choices: %w[active paused archived]

      # Boolean Group — multi-checkbox with CSV storage
      field :permissions, type: :boolean_group, choices: %w[read write deploy admin]

      # External Image — URL-based image display with XSS protection
      field :cover_image_url, type: :external_image, height: "h-40"

      # Progress Bar — percentage bar with min/max range
      field :progress, type: :progress_bar, color: "bg-emerald-500"

      # Key Value — JSON-backed key/value editor
      field :config, type: :key_value

      # Code — monospace code block display
      field :deploy_script, type: :code, language: "bash", rows: 8

      # Hidden — form-only field, never displayed on show/index
      field :api_key, type: :hidden

      searchable :name
      index_fields :id, :name, :status, :progress, :permissions, :created_at
      menu priority: 4, icon: "folder", group: "Content"
    end
  end
end
