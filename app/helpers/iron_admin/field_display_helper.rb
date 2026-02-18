# frozen_string_literal: true

module IronAdmin
  # Private helper methods for rendering specific field types.
  # Extracted from ApplicationHelper for organization.
  module FieldDisplayHelper # rubocop:disable Metrics/ModuleLength
    private

    def display_hidden(_record, _field)
      nil
    end

    def display_radio(record, field)
      value = record.public_send(field.name)
      return if value.blank?

      content_tag(:span, value.to_s.humanize, class: "text-sm #{cp_body_text}")
    end

    def display_code(record, field)
      value = record.public_send(field.name)
      return if value.blank?

      lang = field.options[:language].presence || ""
      content_tag(:pre, class: "overflow-x-auto rounded-lg bg-gray-900 p-4 text-sm") do
        content_tag(:code, value, class: "text-gray-100 font-mono language-#{lang}")
      end
    end

    def display_belongs_to(record, field)
      associated = record.public_send(field.name)
      return if associated.nil?

      display_method = field.options[:display]
      label = display_record_label(associated, display_method)

      resource = IronAdmin::ResourceRegistry.find(associated.class.model_name.plural)
      if resource
        link_to label, iron_admin.resource_path(resource.resource_name, associated),
                class: cp_link
      else
        label
      end
    end

    def display_badge(record, field)
      value = record.public_send(field.name)
      return if value.nil?

      colors = field.options[:colors] || {}
      color = colors[value.to_sym] ||
              IronAdmin.configuration.badge_colors[value.to_s] ||
              IronAdmin.configuration.badge_colors[value] ||
              :gray
      color_classes = badge_color_classes(color)

      content_tag(:span, value.to_s.humanize,
                  class: "inline-flex px-2 py-1 text-xs font-semibold rounded-full #{color_classes}")
    end

    def badge_color_classes(color)
      IronAdmin::Configuration::BADGE_COLOR_CLASSES[color.to_sym] ||
        IronAdmin::Configuration::BADGE_COLOR_CLASSES[:gray]
    end

    def display_password
      content_tag(:span, "\u2022" * 8, class: "text-gray-400 tracking-wider")
    end

    def display_file(record, field)
      return unless record.respond_to?(field.name)

      attachment = record.public_send(field.name)
      return unless attachment.attached?

      if attachment.image?
        image_tag main_app.url_for(attachment), class: "h-16 w-16 object-cover rounded"
      else
        content_tag(:span, class: "inline-flex items-center gap-1.5") do
          heroicon("paper-clip", variant: :mini, options: { class: "h-4 w-4 #{cp_muted_text}" }) +
            content_tag(:span, attachment.filename.to_s, class: cp_link)
        end
      end
    end

    def display_files(record, field)
      return unless record.respond_to?(field.name)

      attachments = record.public_send(field.name)
      return unless attachments.attached?

      content_tag(:div, class: "flex flex-wrap gap-2") do
        safe_join(
          attachments.map do |attachment|
            if attachment.image?
              image_tag main_app.url_for(attachment), class: "h-12 w-12 object-cover rounded"
            else
              content_tag(:span, attachment.filename.to_s,
                          class: "inline-flex items-center px-2 py-1 text-xs rounded bg-gray-100 text-gray-700")
            end
          end
        )
      end
    end

    def display_rich_text(record, field)
      content = record.public_send(field.name)
      return if content.blank?

      content_tag(:div, content.to_s.html_safe, class: "prose prose-sm max-w-none") # rubocop:disable Rails/OutputSafety
    end

    def display_markdown(record, field)
      content = record.public_send(field.name)
      return if content.blank?

      begin
        require "redcarpet"
        renderer = Redcarpet::Render::HTML.new(hard_wrap: true, filter_html: true)
        markdown = Redcarpet::Markdown.new(renderer, autolink: true, tables: true, fenced_code_blocks: true)
        content_tag(:div, markdown.render(content).html_safe, class: "prose prose-sm max-w-none") # rubocop:disable Rails/OutputSafety
      rescue LoadError
        content_tag(:pre, content, class: "text-sm whitespace-pre-wrap #{cp_body_text}")
      end
    end

    def display_tags(record, field)
      value = record.public_send(field.name)
      return if value.blank?

      tags = value.is_a?(Array) ? value : value.to_s.split(",").map(&:strip)
      return if tags.empty?

      content_tag(:div, class: "flex flex-wrap gap-1") do
        safe_join(
          tags.map do |tag|
            content_tag(:span, tag,
                        class: "inline-flex px-2 py-0.5 text-xs font-medium rounded-full bg-indigo-50 text-indigo-700")
          end
        )
      end
    end

    def display_url(record, field)
      value = record.public_send(field.name)
      return if value.blank?

      content_tag(:span, class: "inline-flex items-center gap-1") do
        link_to(value, value, target: "_blank", rel: "noopener noreferrer", class: cp_link) +
          heroicon("arrow-top-right-on-square", variant: :mini, options: { class: "h-3.5 w-3.5 #{cp_muted_text}" })
      end
    end

    def display_email(record, field)
      value = record.public_send(field.name)
      return if value.blank?

      link_to(value, "mailto:#{value}", class: cp_link)
    end

    def display_color(record, field)
      value = record.public_send(field.name)
      return if value.blank?

      content_tag(:span, class: "inline-flex items-center gap-2") do
        content_tag(:span, "", class: "inline-block h-5 w-5 rounded border border-gray-300",
                               style: "background-color: #{ERB::Util.html_escape(value)}") +
          content_tag(:code, value, class: "text-xs #{cp_muted_text}")
      end
    end

    def display_currency(record, field)
      value = record.public_send(field.name)
      return if value.nil?

      symbol = field.options[:symbol] || "$"
      precision = field.options[:precision] || 2
      formatted = number_with_delimiter(format("%.#{precision}f", value.to_f))
      content_tag(:span, "#{symbol}#{formatted}", class: "tabular-nums")
    end

    def display_boolean(record, field)
      value = record.public_send(field.name)

      if value
        heroicon("check-circle", variant: :mini, options: { class: "h-5 w-5 text-green-500" })
      else
        heroicon("x-circle", variant: :mini, options: { class: "h-5 w-5 text-red-400" })
      end
    end

    def display_date(record, field)
      value = record.public_send(field.name)
      return if value.nil?

      fmt = field.options[:format] || "%b %d, %Y"
      value.strftime(fmt)
    end

    def display_datetime(record, field)
      value = record.public_send(field.name)
      return if value.nil?

      fmt = field.options[:format] || "%b %d, %Y at %l:%M %p"
      value.strftime(fmt).squish
    end

    def display_polymorphic_belongs_to(record, field)
      type_value = record.public_send(field.options[:type_column])
      id_value = record.public_send(field.options[:id_column])
      return if type_value.blank? || id_value.blank?

      begin
        associated = type_value.constantize.find_by(id: id_value)
        return "#{type_value}##{id_value}" unless associated

        resource = IronAdmin::ResourceRegistry.find(associated.class.model_name.plural)
        label = display_record_label(associated)
        type_label = type_value.underscore.humanize

        if resource
          content_tag(:span, class: "inline-flex items-center gap-1.5") do
            content_tag(:span, type_label, class: "text-xs #{cp_muted_text}") +
              link_to(label, iron_admin.resource_path(resource.resource_name, associated), class: cp_link)
          end
        else
          "#{type_label}: #{label}"
        end
      rescue NameError
        "#{type_value}##{id_value}"
      end
    end

    def display_external_image(record, field)
      url = record.public_send(field.name)
      return if url.blank?
      return if url.to_s.match?(/\Ajavascript:/i)

      height = field.options[:height] || "h-32"
      tag.img(
        src: url,
        alt: "",
        class: "#{height} w-auto object-cover rounded border border-gray-200",
        loading: "lazy",
        onerror: "this.style.display='none'"
      )
    end

    def display_progress_bar(record, field)
      value = record.public_send(field.name)
      return if value.nil?

      pct = calculate_progress_percentage(value, field)
      color = field.options[:color] || "bg-indigo-600"

      content_tag(:div, class: "flex items-center gap-2") do
        progress_bar_track(pct, color) +
          content_tag(:span, "#{value.to_i}%", class: "text-xs tabular-nums #{cp_muted_text}")
      end
    end

    def calculate_progress_percentage(value, field)
      min = (field.options[:min] || 0).to_f
      max = (field.options[:max] || 100).to_f
      ((value.to_f - min) / (max - min) * 100.0).clamp(0.0, 100.0)
    end

    def progress_bar_track(pct, color)
      content_tag(:div, class: "flex-1 h-2 rounded-full bg-gray-200 overflow-hidden") do
        content_tag(:div, "", class: "h-2 rounded-full #{color}", style: "width: #{pct.round(1)}%")
      end
    end
  end
end
