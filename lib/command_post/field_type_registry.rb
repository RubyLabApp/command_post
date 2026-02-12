# frozen_string_literal: true

module CommandPost
  class FieldTypeRegistry
    class << self
      def register(type_name, &)
        raise ArgumentError, "Field type :#{type_name} is already registered" if registered?(type_name)

        config = FieldTypeConfig.new
        config.instance_eval(&)
        registry[type_name.to_sym] = config
      end

      def find(type_name)
        registry[type_name.to_sym]
      end

      def registered?(type_name)
        registry.key?(type_name.to_sym)
      end

      def reset!
        @registry = {}
      end

      private

      def registry
        @registry ||= {}
      end
    end
  end
end
