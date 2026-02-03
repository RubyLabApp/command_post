module CommandPost
  class Field
    attr_reader :name, :type, :visible, :readonly, :options

    def initialize(name, **options)
      @name = name
      @type = options.delete(:type)
      @visible = options.delete(:visible) { true }
      @readonly = options.delete(:readonly) { false }
      @options = options
    end

    def visible?(user)
      evaluate(@visible, user)
    end

    def readonly?(user)
      evaluate(@readonly, user)
    end

    private

    def evaluate(value, context)
      value.is_a?(Proc) ? value.call(context) : value
    end
  end
end
