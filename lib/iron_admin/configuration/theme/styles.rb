# frozen_string_literal: true

module IronAdmin
  class Configuration
    class Theme
      # Lightweight container for a group of style tokens.
      #
      # Each theme sub-group (button, badge, form, etc.) is a Styles instance
      # whose keys are defined at construction time from the preset defaults.
      #
      # Supports both method-style access (`styles.base`) and hash-style
      # access (`styles[:base]`) for keys that hold simple string values,
      # and Hash-typed keys (e.g., `variants`, `colors`, `sizes`) are
      # stored as plain hashes accessible via their accessor.
      #
      # @example
      #   styles = Styles.new(base: "inline-flex", variants: { primary: "bg-blue" })
      #   styles.base          #=> "inline-flex"
      #   styles[:base]        #=> "inline-flex"
      #   styles.variants      #=> { primary: "bg-blue" }
      class Styles
        # @param attrs [Hash] Initial key-value pairs for this style group
        def initialize(**attrs)
          attrs.each do |key, value|
            instance_variable_set(:"@#{key}", value.is_a?(Hash) ? value.dup : value)
            define_singleton_accessor(key)
          end
        end

        # Hash-style read access.
        # @param key [Symbol] The style token name
        # @return [String, Hash, nil]
        def [](key)
          public_send(key) if respond_to?(key)
        end

        # Hash-style write access.
        # @param key [Symbol] The style token name
        # @param value [String, Hash]
        def []=(key, value)
          setter = :"#{key}="
          if respond_to?(setter)
            public_send(setter, value)
          else
            instance_variable_set(:"@#{key}", value)
            define_singleton_accessor(key)
          end
        end

        private

        def define_singleton_accessor(key)
          define_singleton_method(key) { instance_variable_get(:"@#{key}") } unless respond_to?(key)
          define_singleton_method(:"#{key}=") { |v| instance_variable_set(:"@#{key}", v) } unless respond_to?(:"#{key}=")
        end
      end
    end
  end
end
