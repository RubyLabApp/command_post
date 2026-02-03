CommandPost::Engine.routes.draw do
  root "dashboard#index"

  get "search", to: "search#index", as: :search
  get ":resource_name/export", to: "exports#show", as: :export

  get ":resource_name", to: "resources#index", as: :resources
  get ":resource_name/new", to: "resources#new", as: :new_resource
  get ":resource_name/:id", to: "resources#show", as: :resource
  get ":resource_name/:id/edit", to: "resources#edit", as: :edit_resource
  post ":resource_name", to: "resources#create"
  patch ":resource_name/:id", to: "resources#update"
  delete ":resource_name/:id", to: "resources#destroy"
  post ":resource_name/:id/actions/:action_name", to: "resources#execute_action", as: :resource_action
  post ":resource_name/bulk_actions/:action_name", to: "resources#execute_bulk_action", as: :resource_bulk_action
end
