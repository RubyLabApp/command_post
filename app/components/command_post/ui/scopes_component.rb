# frozen_string_literal: true

module CommandPost
  module Ui
    # Renders scope tabs for filtering resource lists.
    #
    # @example Scopes from resource
    #   render CommandPost::Ui::ScopesComponent.new(
    #     scopes: @resource_class.all_scopes,
    #     current_scope: @current_scope,
    #     base_path: resources_path(@resource_class.resource_name)
    #   )
    class ScopesComponent < ViewComponent::Base
      # @return [Array<Hash>] Scope definitions
      attr_reader :scopes

      # @return [String, nil] Currently active scope name
      attr_reader :current_scope

      # @return [String] Base URL path
      attr_reader :base_path

      # @return [Hash] Additional query params
      attr_reader :params

      # @param scopes [Array<Hash>] Scope definitions
      # @param current_scope [String, nil] Active scope name
      # @param base_path [String] Base URL
      # @param params [Hash] Additional query params
      def initialize(scopes:, current_scope:, base_path:, params: {})
        @scopes = scopes
        @current_scope = current_scope
        @base_path = base_path
        @params = params
      end

      # @api private
      # @return [CommandPost::Configuration::Theme] Theme configuration
      def theme
        CommandPost.configuration.theme
      end

      # @api private
      # @param scope_name [Symbol, String] Scope name
      # @return [String] URL with scope parameter
      def scope_url(scope_name)
        "#{base_path}?#{params.merge(scope: scope_name).to_query}"
      end

      # @api private
      # @param scope [Hash] Scope definition
      # @return [Boolean] Whether scope is currently active
      def active?(scope)
        current_scope == scope[:name].to_s
      end

      # @api private
      # @param scope [Hash] Scope definition
      # @return [String] CSS classes for scope tab
      def scope_classes(scope)
        base = "px-4 py-2 text-sm font-medium border-b-2 -mb-px transition-colors duration-150"
        if active?(scope)
          "#{base} #{theme.scope_active}"
        else
          "#{base} #{theme.scope_inactive}"
        end
      end

      # @api private
      # @return [Boolean] Whether to render the component
      def render?
        scopes.any?
      end
    end
  end
end
