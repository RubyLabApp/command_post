# frozen_string_literal: true

module IronAdmin
  class FieldTypeConfig
    attr_reader :form_component_class, :form_partial_path

    def initialize
      @display_block = nil
      @index_display_block = nil
      @form_component_class = nil
      @form_partial_path = nil
    end

    def display(&block)
      @display_block = block if block
    end

    def index_display(&block)
      @index_display_block = block if block
    end

    def form_component(klass)
      @form_component_class = klass
    end

    def form_partial(path)
      @form_partial_path = path
    end

    def render_display(record, field)
      return unless @display_block

      @display_block.call(record, field)
    end

    def render_index_display(record, field)
      if @index_display_block
        @index_display_block.call(record, field)
      else
        render_display(record, field)
      end
    end
  end
end
