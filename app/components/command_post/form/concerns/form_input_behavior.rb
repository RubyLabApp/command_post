module CommandPost
  module Form
    module Concerns
      module FormInputBehavior
        extend ActiveSupport::Concern

        included do
          attr_reader :field, :current_user, :disabled
        end

        def effectively_disabled?
          disabled || field_readonly?
        end

        def field_readonly?
          @field&.readonly?(@current_user) || false
        end

        def theme
          CommandPost.configuration.theme
        end
      end
    end
  end
end
