module CommandPost
  module UI
    class ScopesComponent < ViewComponent::Base
      attr_reader :scopes, :current_scope, :base_path, :params

      def initialize(scopes:, current_scope:, base_path:, params: {})
        @scopes = scopes
        @current_scope = current_scope
        @base_path = base_path
        @params = params
      end

      def theme
        CommandPost.configuration.theme
      end

      def scope_url(scope_name)
        "#{base_path}?#{params.merge(scope: scope_name).to_query}"
      end

      def active?(scope)
        current_scope == scope[:name].to_s
      end

      def scope_classes(scope)
        base = "px-4 py-2 text-sm font-medium border-b-2 -mb-px transition-colors duration-150"
        if active?(scope)
          "#{base} #{theme.scope_active}"
        else
          "#{base} #{theme.scope_inactive}"
        end
      end

      def render?
        scopes.any?
      end
    end
  end
end
