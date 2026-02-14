# frozen_string_literal: true

module IronAdmin
  # Controller for global search across all resources.
  #
  # Searches all registered resources and returns matching records.
  class SearchController < ApplicationController
    # Renders global search results.
    # @return [void]
    def index
      @query = params[:q].to_s.strip
      @results = search_all_resources if @query.present?
    end

    private

    def search_all_resources
      ResourceRegistry.all.filter_map do |resource_class|
        columns = resource_class.searchable_columns
        next if columns.empty?

        conn = resource_class.model.connection
        table = conn.quote_table_name(resource_class.model.table_name)
        like_operator = conn.adapter_name.downcase.include?("postgresql") ? "ILIKE" : "LIKE"
        conditions = columns.map { |col| "#{table}.#{conn.quote_column_name(col)} #{like_operator} :q" }
        records = resource_class.model.where(conditions.join(" OR "), q: "%#{@query}%").limit(5)

        next if records.empty?

        { resource: resource_class, records: records }
      end
    end
  end
end
