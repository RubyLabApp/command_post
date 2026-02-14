# frozen_string_literal: true

module IronAdmin
  # Controller for the admin dashboard.
  #
  # Renders the configured dashboard class with widgets and metrics.
  class DashboardController < ApplicationController
    # Renders the dashboard index page.
    # @return [void]
    def index
      @dashboard = IronAdmin.dashboard_class
    end
  end
end
