module CommandPost
  module Layout
    class ShellComponent < ViewComponent::Base
      renders_one :sidebar, SidebarComponent
      renders_one :navbar, NavbarComponent

      def initialize(current_user: nil)
        @current_user = current_user
      end

      def before_render
        with_sidebar unless sidebar?
        with_navbar(current_user: @current_user) unless navbar?
      end
    end
  end
end
