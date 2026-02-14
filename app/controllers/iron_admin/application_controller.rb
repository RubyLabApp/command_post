# frozen_string_literal: true

module IronAdmin
  # Base controller for all IronAdmin admin panel controllers.
  #
  # Provides authentication and current user handling for the admin panel.
  # All other IronAdmin controllers inherit from this class.
  #
  # @see IronAdmin::Configuration#authenticate
  # @see IronAdmin::Configuration#current_user
  class ApplicationController < ::ActionController::Base
    include Pagy::Method

    before_action :authenticate_iron_admin_user!

    helper_method :iron_admin_current_user

    private

    # @api private
    def authenticate_iron_admin_user!
      return unless IronAdmin.configuration.authenticate_block

      instance_exec(self, &IronAdmin.configuration.authenticate_block)
    end

    # @api private
    def iron_admin_current_user
      return unless IronAdmin.configuration.current_user_block

      @iron_admin_current_user ||= instance_exec(self, &IronAdmin.configuration.current_user_block)
    end
  end
end
