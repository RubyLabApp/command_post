# frozen_string_literal: true

module CommandPost
  # Main application helper for CommandPost views.
  module ApplicationHelper
    include Heroicon::ApplicationHelper
    include CommandPost::ThemeHelper

    # Methods checked when displaying a record's label.
    # @return [Array<Symbol>]
    DISPLAY_METHODS = %i[name title email label slug].freeze

    # Displays a field value with appropriate formatting.
    #
    # @param record [ActiveRecord::Base] The record
    # @param field [CommandPost::Field] Field configuration
    # @return [String, nil] Formatted value
    def display_field_value(record, field)
      case field.type
      when :belongs_to
        display_belongs_to(record, field)
      when :badge
        display_badge(record, field)
      else
        record.public_send(field.name)
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
        [%w[Yes true], %w[No false]]
      else
        []
      end
    end

    private

    def display_belongs_to(record, field)
      associated = record.public_send(field.name)
      return if associated.nil?

      display_method = field.options[:display]
      label = display_record_label(associated, display_method)

      resource = CommandPost::ResourceRegistry.find(associated.class.model_name.plural)
      if resource
        link_to label, command_post.resource_path(resource.resource_name, associated),
                class: cp_link
      else
        label
      end
    end

    def display_badge(record, field)
      value = record.public_send(field.name)
      return if value.nil?

      # First check field-level color overrides, then global badge_colors, then default to gray
      colors = field.options[:colors] || {}
      color = colors[value.to_sym] ||
              CommandPost.configuration.badge_colors[value.to_s] ||
              CommandPost.configuration.badge_colors[value] ||
              :gray
      color_classes = badge_color_classes(color)

      content_tag(:span, value.to_s.humanize,
                  class: "inline-flex px-2 py-1 text-xs font-semibold rounded-full #{color_classes}")
    end

    def badge_color_classes(color)
      CommandPost::Configuration::BADGE_COLOR_CLASSES[color.to_sym] ||
        CommandPost::Configuration::BADGE_COLOR_CLASSES[:gray]
    end
  end
end
