module CommandPost
  class DashboardController < ApplicationController
    def index
      @dashboard = CommandPost.dashboard_class
    end
  end
end
