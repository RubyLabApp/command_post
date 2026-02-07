# frozen_string_literal: true

module CommandPost
  module Layout
    # Renders the top navigation bar.
    class NavbarComponent < ViewComponent::Base
      # @param current_user [Object, nil] Current user
      def initialize(current_user: nil)
        @current_user = current_user
      end
    end
  end
end
