module CommandPost
  module Resources
    class DataTableComponent < ViewComponent::Base
      renders_one :empty_state

      attr_reader :records, :fields, :resource_class, :current_sort, :current_direction, :base_url, :current_user

      def initialize(records:, fields:, resource_class:, base_url:, current_sort: nil,
                     current_direction: nil, current_user: nil)
        @records = records
        @fields = fields
        @resource_class = resource_class
        @current_sort = current_sort
        @current_direction = current_direction
        @base_url = base_url
        @current_user = current_user
      end

      def visible_fields
        @visible_fields ||= @fields.select { |f| f.visible?(@current_user) }
      end

      def theme
        CommandPost.configuration.theme
      end

      def table_classes
        "min-w-full divide-y #{theme.card_bg} #{theme.border_radius} #{theme.card_shadow}"
      end

      def header_classes
        theme.table_header_bg
      end

      delegate :empty?, to: :records

      def sort_url(field_name)
        direction = current_sort == field_name.to_s && current_direction == "asc" ? "desc" : "asc"
        "#{base_url}&sort=#{field_name}&direction=#{direction}"
      end

      def sorted?(field_name)
        current_sort == field_name.to_s
      end

      def sort_direction
        current_direction
      end
    end
  end
end
