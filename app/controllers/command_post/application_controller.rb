# frozen_string_literal: true

module CommandPost
  # Base controller for all CommandPost admin panel controllers.
  #
  # Provides authentication and current user handling for the admin panel.
  # All other CommandPost controllers inherit from this class.
  #
  # @see CommandPost::Configuration#authenticate
  # @see CommandPost::Configuration#current_user
  class ApplicationController < ::ActionController::Base
    include Pagy::Method

    before_action :authenticate_command_post_user!

    helper_method :command_post_current_user

    private

    # @api private
    def authenticate_command_post_user!
      return unless CommandPost.configuration.authenticate_block

      instance_exec(self, &CommandPost.configuration.authenticate_block)
    end

    # @api private
    def command_post_current_user
      return unless CommandPost.configuration.current_user_block

      @command_post_current_user ||= instance_exec(self, &CommandPost.configuration.current_user_block)
    end
  end
end
