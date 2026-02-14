# frozen_string_literal: true

module IronAdmin
  module Layout
    # Renders the top navigation bar.
    class NavbarComponent < ViewComponent::Base
      include IronAdmin::ThemeHelper

      # @param current_user [Object, nil] Current user
      def initialize(current_user: nil)
        @current_user = current_user
      end
    end
  end
end
