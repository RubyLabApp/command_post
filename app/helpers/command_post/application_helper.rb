module CommandPost
  module ApplicationHelper
    include Heroicon::ApplicationHelper
    include CommandPost::ThemeHelper

    DISPLAY_METHODS = %i[name title email label slug].freeze

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

    def display_record_label(record, display_method = nil)
      if display_method.is_a?(Proc)
        return display_method.call(record)
      end

      if display_method.is_a?(Symbol) || display_method.is_a?(String)
        return record.public_send(display_method)
      end

      DISPLAY_METHODS.each do |method|
        return record.public_send(method) if record.respond_to?(method) && record.public_send(method).present?
      end

      "#{record.class.model_name.human} ##{record.id}"
    end

    def filter_options_for(resource_class, filter)
      model = resource_class.model
      column_name = filter[:name].to_s

      case filter[:type]
      when :select
        if model.defined_enums.key?(column_name)
          model.defined_enums[column_name].keys.map { |k| [ k.humanize, k ] }
        elsif filter[:options]
          filter[:options]
        else
          model.distinct.pluck(column_name).compact.sort.map { |v| [ v.to_s.humanize, v ] }
        end
      when :boolean
        [ [ "Yes", "true" ], [ "No", "false" ] ]
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

      colors = field.options[:colors] || {}
      color = colors[value.to_sym] || :gray
      color_classes = badge_color_classes(color)

      content_tag(:span, value.to_s.humanize, class: "inline-flex px-2 py-1 text-xs font-semibold rounded-full #{color_classes}")
    end

    def badge_color_classes(color)
      colors = CommandPost.configuration.badge_colors
      colors[color.to_sym] || colors[:gray] || "bg-gray-100 text-gray-800"
    end
  end
end
