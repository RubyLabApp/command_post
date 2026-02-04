module CommandPost
  module Filters
    class SearchComponent < ViewComponent::Base
      attr_reader :value, :placeholder, :form_url, :hidden_params

      def initialize(form_url:, value: nil, placeholder: "Search...", hidden_params: {})
        @value = value
        @placeholder = placeholder
        @form_url = form_url
        @hidden_params = hidden_params
      end

      def theme
        CommandPost.configuration.theme
      end

      def input_classes
        "block w-full border py-2 pl-10 pr-4 text-sm shadow-sm outline-none " \
          "transition duration-150 ease-in-out #{theme.border_radius} #{theme.input_border} " \
          "#{theme.navbar_search_bg} #{theme.body_text} #{theme.input_focus} #{theme.navbar_search_focus_bg}"
      end
    end
  end
end
