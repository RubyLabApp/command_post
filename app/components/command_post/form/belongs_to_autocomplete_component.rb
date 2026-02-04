module CommandPost
  module Form
    class BelongsToAutocompleteComponent < ViewComponent::Base
      attr_reader :name, :resource_name, :selected_id, :selected_label, :placeholder,
                  :disabled, :has_error, :field, :current_user
      attr_accessor :autocomplete_url

      def initialize(name:, resource_name:, selected_id: nil, selected_label: nil,
                     placeholder: nil, disabled: false, has_error: false,
                     field: nil, current_user: nil)
        @name = name
        @resource_name = resource_name
        @selected_id = selected_id
        @selected_label = selected_label
        @placeholder = placeholder || "Search..."
        @disabled = disabled
        @has_error = has_error
        @field = field
        @current_user = current_user
      end

      def before_render
        @autocomplete_url ||= helpers.command_post.autocomplete_path(resource_name)
      end

      def theme
        CommandPost.configuration.theme
      end

      def effectively_disabled?
        disabled || field_readonly?
      end

      def field_readonly?
        @field&.readonly?(@current_user) || false
      end

      def input_classes
        base = "block w-full border px-3 py-2 text-sm shadow-sm outline-none transition duration-150 ease-in-out " \
               "#{theme.border_radius} #{theme.input_border} #{theme.card_bg} #{theme.body_text} #{theme.input_focus}"
        base += " !border-red-400 !focus:border-red-500 !focus:ring-red-500/20" if has_error
        base += " bg-gray-50 cursor-not-allowed" if effectively_disabled?
        base
      end

      def dropdown_classes
        "absolute z-50 mt-1 w-full max-h-60 overflow-auto #{theme.border_radius} " \
        "#{theme.card_bg} border #{theme.input_border} shadow-lg"
      end

      def dropdown_item_classes
        "px-3 py-2 text-sm cursor-pointer hover:bg-gray-100 #{theme.body_text}"
      end

      def component_id
        @component_id ||= "autocomplete-#{SecureRandom.hex(4)}"
      end
    end
  end
end
