module CommandPost
  class Policy
    def initialize(&)
      @allow_rules = {}
      @deny_rules = {}
      @configured = block_given?
      instance_eval(&) if block_given?
    end

    def allow(*actions, if: nil)
      condition = binding.local_variable_get(:if)
      actions.each { |action| @allow_rules[action] = condition }
    end

    def deny(*actions, if: nil)
      condition = binding.local_variable_get(:if)
      actions.each { |action| @deny_rules[action] = condition }
    end

    def allowed?(action, user)
      return true unless @configured
      return false unless @allow_rules.key?(action)

      condition = @allow_rules[action]
      condition.nil? || condition.call(user)
    end

    def denied?(action, _user, record)
      condition = @deny_rules[action]
      return false unless condition

      condition.call(record)
    end
  end
end
