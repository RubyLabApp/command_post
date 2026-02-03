module CommandPost
  class ApplicationController < ::ActionController::Base
    include Pagy::Method

    before_action :authenticate_command_post_user!

    helper_method :command_post_current_user

    private

    def authenticate_command_post_user!
      return unless CommandPost.configuration.authenticate_block

      instance_exec(self, &CommandPost.configuration.authenticate_block)
    end

    def command_post_current_user
      return unless CommandPost.configuration.current_user_block

      @command_post_current_user ||= instance_exec(self, &CommandPost.configuration.current_user_block)
    end
  end
end
