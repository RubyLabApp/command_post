module CommandPost
  module Layout
    class NavbarComponent < ViewComponent::Base
      def initialize(current_user: nil)
        @current_user = current_user
      end
    end
  end
end
