module CommandPost
  class Dashboard
    class_attribute :defined_metrics, default: []
    class_attribute :defined_charts, default: []
    class_attribute :defined_recents, default: []
    class_attribute :_layout_block, default: nil

    class << self
      def inherited(subclass)
        super
        CommandPost.dashboard_class = subclass
      end

      def metric(name, format: :number, &block)
        self.defined_metrics = defined_metrics + [{ name: name, format: format, block: block }]
      end

      def chart(name, type: :line, &block)
        self.defined_charts = defined_charts + [{ name: name, type: type, block: block }]
      end

      def recent(resource_name, limit: 5, scope: nil)
        self.defined_recents = defined_recents + [{ resource_name: resource_name, limit: limit, scope: scope }]
      end

      def layout(&block)
        self._layout_block = block
      end
    end
  end
end
