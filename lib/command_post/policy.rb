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

    # Check if a custom action (or bulk action) is allowed
    # Same logic as allowed? - returns true if no policy configured,
    # false if action not in allow list, or evaluates condition
    def action_allowed?(action_name, user)
      return true unless @configured
      return false unless @allow_rules.key?(action_name)

      condition = @allow_rules[action_name]
      condition.nil? || condition.call(user)
    end
  end
end
