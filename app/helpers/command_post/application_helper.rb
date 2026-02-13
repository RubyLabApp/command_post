# frozen_string_literal: true

module CommandPost
  # Main application helper for CommandPost views.
  module ApplicationHelper
    include Heroicon::ApplicationHelper
    include CommandPost::ThemeHelper
    include CommandPost::FieldDisplayHelper

    # Methods checked when displaying a record's label.
    # @return [Array<Symbol>]
    DISPLAY_METHODS = %i[name title email label slug].freeze

    # Default max characters for text truncation on index pages.
    INDEX_TRUNCATION_LENGTH = 50

    # Field types that should be truncated on index pages.
    TRUNCATABLE_TYPES = %i[text textarea].freeze

    # Maps field types to their display method names.
    # @return [Hash{Symbol => Symbol}]
    FIELD_DISPLAY_METHODS = {
      belongs_to: :display_belongs_to,
      badge: :display_badge,
      password: :display_password,
      file: :display_file,
      files: :display_files,
      rich_text: :display_rich_text,
      tags: :display_tags,
      markdown: :display_markdown,
      url: :display_url,
      email: :display_email,
      color: :display_color,
      currency: :display_currency,
      boolean: :display_boolean,
      date: :display_date,
      datetime: :display_datetime,
      polymorphic_belongs_to: :display_polymorphic_belongs_to,
    }.freeze

    # Displays a field value with appropriate formatting.
    #
    # @param record [ActiveRecord::Base] The record
    # @param field [CommandPost::Field] Field configuration
    # @return [String, nil] Formatted value
    def display_field_value(record, field)
      method_name = FIELD_DISPLAY_METHODS[field.type]
      if method_name
        method_name == :display_password ? display_password : send(method_name, record, field)
      elsif (custom = CommandPost::FieldTypeRegistry.find(field.type))
        custom.render_display(record, field)
      else
        record.public_send(field.name)
      end
    end

    # Displays a field value for index pages with text truncation.
    #
    # @param record [ActiveRecord::Base] The record
    # @param field [CommandPost::Field] Field configuration
    # @return [String, nil] Formatted value (truncated for text fields)
    def display_index_field_value(record, field)
      if TRUNCATABLE_TYPES.include?(field.type)
        value = record.public_send(field.name)
        return if value.blank?

        truncated = truncate(value.to_s, length: INDEX_TRUNCATION_LENGTH)
        if value.to_s.length > INDEX_TRUNCATION_LENGTH
          content_tag(:span, truncated, title: value.to_s)
        else
          truncated
        end
      elsif (custom = CommandPost::FieldTypeRegistry.find(field.type))
        custom.render_index_display(record, field)
      else
        display_field_value(record, field)
      end
    end

    # Returns a display label for a record.
    #
    # @param record [ActiveRecord::Base] The record
    # @param display_method [Symbol, Proc, nil] Custom display method
    # @return [String] Display label
    def display_record_label(record, display_method = nil)
      return display_method.call(record) if display_method.is_a?(Proc)

      return record.public_send(display_method) if display_method.is_a?(Symbol) || display_method.is_a?(String)

      DISPLAY_METHODS.each do |method|
        return record.public_send(method) if record.respond_to?(method) && record.public_send(method).present?
      end

      "#{record.class.model_name.human} ##{record.id}"
    end

    # Returns options for a filter select dropdown.
    #
    # @param resource_class [Class] The resource class
    # @param filter [Hash] Filter configuration
    # @return [Array<Array(String, String)>] Options for select tag
    def filter_options_for(resource_class, filter)
      model = resource_class.model
      column_name = filter[:name].to_s

      case filter[:type]
      when :select
        if model.defined_enums.key?(column_name)
          model.defined_enums[column_name].keys.map { |k| [k.humanize, k] }
        elsif filter[:options]
          filter[:options]
        else
          model.distinct.pluck(column_name).compact.sort.map { |v| [v.to_s.humanize, v] }
        end
      when :boolean
        [[I18n.t("command_post.filters.true"), "true"], [I18n.t("command_post.filters.false"), "false"]]
      else
        []
      end
    end
  end
end
