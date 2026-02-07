# frozen_string_literal: true

module CommandPost
  # Controller for the admin dashboard.
  #
  # Renders the configured dashboard class with widgets and metrics.
  class DashboardController < ApplicationController
    # Renders the dashboard index page.
    # @return [void]
    def index
      @dashboard = CommandPost.dashboard_class
    end
  end
end
