# frozen_string_literal: true

module IronAdmin
  module Form
    # Renders a select dropdown for belongs_to associations.
    #
    # @example Basic belongs_to select
    #   render IronAdmin::Form::BelongsToComponent.new(
    #     name: "record[organization_id]",
    #     association_class: Organization,
    #     selected: @record.organization_id
    #   )
    class BelongsToComponent < ViewComponent::Base
      # Default limit for options before suggesting autocomplete.
      # @return [Integer]
      DEFAULT_OPTIONS_LIMIT = 100

      # @return [String] Select name attribute
      attr_reader :name

      # @return [Class] The associated model class
      attr_reader :association_class

      # @return [Integer, nil] Currently selected ID
      attr_reader :selected

      # @return [Symbol] Method to call for display text
      attr_reader :display_method

      # @return [Boolean] Whether to include blank option
      attr_reader :include_blank

      # @return [Boolean] Whether input is disabled
      attr_reader :disabled

      # @return [Boolean] Whether input has error state
      attr_reader :has_error

      # @return [Integer] Max options to load
      attr_reader :options_limit

      # @return [Proc, nil] Custom scope for options
      attr_reader :options_scope

      # @param name [String] Select name
      # @param association_class [Class] Associated model class
      # @param selected [Integer, nil] Selected ID
      # @param display_method [Symbol] Display method (default: :name)
      # @param include_blank [Boolean] Include blank option
      # @param disabled [Boolean] Disabled state
      # @param has_error [Boolean] Error state
      # @param options_limit [Integer] Max options
      # @param options_scope [Proc, nil] Custom scope
      def initialize(name:, association_class:, selected: nil, display_method: :name,
                     include_blank: true, disabled: false, has_error: false,
                     options_limit: DEFAULT_OPTIONS_LIMIT, options_scope: nil)
        @name = name
        @association_class = association_class
        @selected = selected
        @display_method = display_method
        @include_blank = include_blank
        @disabled = disabled
        @has_error = has_error
        @options_limit = options_limit
        @options_scope = options_scope
      end

      # @api private
      # @return [IronAdmin::Configuration::Theme] Theme configuration
      def theme
        IronAdmin.configuration.theme
      end

      # @api private
      # @return [Array<Array(String, Integer)>] Options array for select tag
      def options
        scope = options_scope ? association_class.instance_exec(&options_scope) : association_class.all
        scope.limit(options_limit).map do |record|
          [record.public_send(display_method), record.id]
        end
      end

      # @api private
      # @return [Boolean] Whether to show hint about more records available
      def show_search_hint?
        association_class.count > options_limit
      end

      # @api private
      # @return [String] CSS classes for select element
      def select_classes
        base = "#{theme.form.input_base} #{theme.form.select_extra} #{theme.border_radius} " \
               "#{theme.input_border} #{theme.card_bg} #{theme.body_text} #{theme.input_focus}"
        base += " #{theme.form.error_border}" if has_error
        base += " #{theme.form.disabled}" if disabled
        base
      end

      # @api private
      # @return [String] Inline CSS style for dropdown chevron
      def chevron_style
        theme.form.select_chevron_style
      end
    end
  end
end
