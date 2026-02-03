require "command_post/configuration/theme"
require "command_post/configuration/components"

module CommandPost
  class Configuration
    attr_accessor :title, :logo, :per_page, :default_sort, :default_sort_direction, :search_engine,
                  :badge_colors
    attr_reader :authenticate_block, :current_user_block, :on_action_block, :theme_config, :components

    DEFAULT_BADGE_COLORS = {
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

    def initialize
      @title = "Admin"
      @per_page = 25
      @default_sort = :created_at
      @default_sort_direction = :desc
      @search_engine = :default
      @badge_colors = DEFAULT_BADGE_COLORS.dup
      @theme_config = Theme.new
      @components = Components.new
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
  end
end
