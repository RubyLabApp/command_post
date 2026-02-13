# frozen_string_literal: true

# Trix editor and ActionText JS for rich_text field support.
# These pins are only effective when the host app has ActionText installed.
pin "trix"
pin "@rails/actiontext", to: "actiontext.esm.js"

# CommandPost Stimulus controllers
pin "command_post", to: "command_post/index.js"
pin "command_post/controllers/cp_bulk_select_controller", to: "command_post/controllers/cp_bulk_select_controller.js"
pin "command_post/controllers/cp_chart_controller", to: "command_post/controllers/cp_chart_controller.js"
