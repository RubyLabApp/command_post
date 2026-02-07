module CommandPost
  class Policy
    # Aliases for CRUD actions - :show/:index map to :read
    ACTION_ALIASES = {
      show: :read,
      index: :read,
    }.freeze

    # Reverse aliases - :read maps to [:show, :index]
    REVERSE_ALIASES = ACTION_ALIASES.each_with_object({}) do |(action, crud), hash|
      (hash[crud] ||= []) << action
    end.freeze

    def initialize(&)
      @allow_rules = {}
      @configured = block_given?
      instance_eval(&) if block_given?
    end

    def allow(*actions, if: nil)
      condition = binding.local_variable_get(:if)
      actions.each { |action| @allow_rules[action] = condition }
    end

    def allowed?(action, user)
      return true unless @configured

      # Check the action directly first
      if @allow_rules.key?(action)
        condition = @allow_rules[action]
        return condition.nil? || condition.call(user)
      end

      # Check forward alias (e.g., :show -> :read)
      aliased_action = ACTION_ALIASES[action]
      if aliased_action && @allow_rules.key?(aliased_action)
        condition = @allow_rules[aliased_action]
        return condition.nil? || condition.call(user)
      end

      # Check reverse aliases (e.g., :read -> [:show, :index])
      reverse_actions = REVERSE_ALIASES[action]
      reverse_actions&.each do |reverse_action|
        next unless @allow_rules.key?(reverse_action)

        condition = @allow_rules[reverse_action]
        return condition.nil? || condition.call(user)
      end

      false
    end

    # Check if a custom action (or bulk action) is allowed
    # Returns true if no policy configured, false if action not in allow list
    def action_allowed?(action_name, user)
      return true unless @configured
      return false unless @allow_rules.key?(action_name)

      condition = @allow_rules[action_name]
      condition.nil? || condition.call(user)
    end
  end
end
