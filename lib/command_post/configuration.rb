require "command_post/configuration/theme"
require "command_post/configuration/components"

module CommandPost
  class Configuration
    attr_accessor :title, :logo, :per_page, :default_sort, :default_sort_direction, :search_engine,
                  :badge_colors, :audit_enabled, :audit_storage
    attr_reader :authenticate_block, :current_user_block, :on_action_block, :theme_config, :components,
                :tenant_scope_block

    BADGE_COLOR_CLASSES = {
      green: "bg-green-100 text-green-800",
      red: "bg-red-100 text-red-800",
      yellow: "bg-yellow-100 text-yellow-800",
      blue: "bg-blue-100 text-blue-800",
      indigo: "bg-indigo-100 text-indigo-800",
      purple: "bg-purple-100 text-purple-800",
      pink: "bg-pink-100 text-pink-800",
      orange: "bg-orange-100 text-orange-800",
      teal: "bg-teal-100 text-teal-800",
      gray: "bg-gray-100 text-gray-800",
    }.freeze

    DEFAULT_BADGE_COLORS = {
      # Common status values
      "active" => "green",
      "inactive" => "gray",
      "enabled" => "green",
      "disabled" => "gray",
      "pending" => "yellow",
      "processing" => "blue",
      "in_progress" => "blue",
      "completed" => "green",
      "done" => "green",
      "success" => "green",
      "failed" => "red",
      "error" => "red",
      "cancelled" => "red",
      "canceled" => "red",
      "rejected" => "red",
      "declined" => "red",
      "approved" => "green",
      "accepted" => "green",
      "published" => "green",
      "unpublished" => "gray",
      "draft" => "gray",
      "archived" => "gray",
      "expired" => "red",
      "suspended" => "red",
      "blocked" => "red",
      # Boolean representations
      true => "green",
      false => "red",
      "true" => "green",
      "false" => "red",
      "yes" => "green",
      "no" => "red",
    }.freeze

    def initialize
      @title = "Admin"
      @per_page = 25
      @default_sort = :created_at
      @default_sort_direction = :desc
      @search_engine = :default
      @badge_colors = DEFAULT_BADGE_COLORS.dup
      @theme_config = Theme.new
      @components = Components.new
      @audit_enabled = false
      @audit_storage = :memory
    end

    def authenticate(&block)
      @authenticate_block = block
    end

    def current_user(&block)
      @current_user_block = block
    end

    def on_action(&block)
      @on_action_block = block
    end

    def theme
      yield @theme_config if block_given?
      @theme_config
    end

    def tenant_scope(&block)
      @tenant_scope_block = block
    end
  end
end
