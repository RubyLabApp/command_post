# frozen_string_literal: true

module CommandPost
  class Configuration
    # Component override configuration for replacing default UI components.
    #
    # Allows replacing the default ViewComponents with custom implementations
    # at the global level. For per-resource overrides, use {Resource.component}.
    #
    # @example Override the table component globally
    #   CommandPost.configure do |config|
    #     config.components.table = MyCustomTableComponent
    #   end
    #
    # @see CommandPost::Resource.component For per-resource overrides
    class Components
      # @return [Class, nil] Custom table component class
      attr_accessor :table

      # @return [Class, nil] Custom form component class
      attr_accessor :form

      # @return [Class, nil] Custom filter bar component class
      attr_accessor :filter_bar

      # @return [Class, nil] Custom search component class
      attr_accessor :search

      # @return [Class, nil] Custom navbar component class
      attr_accessor :navbar

      # @return [Class, nil] Custom sidebar component class
      attr_accessor :sidebar

      # @return [Class, nil] Custom shell/layout component class
      attr_accessor :shell

      # @return [Hash{Symbol => Class}] Field type to component class mappings
      attr_reader :fields

      # Creates a new Components configuration with defaults.
      def initialize
        @fields = {}
      end
    end
  end
end
