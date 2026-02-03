module CommandPost
  class Configuration
    class Components
      attr_accessor :table, :form, :filter_bar, :search, :navbar, :sidebar, :shell
      attr_reader :fields

      def initialize
        @fields = {}
      end
    end
  end
end
