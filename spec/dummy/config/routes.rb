Rails.application.routes.draw do
  mount CommandPost::Engine => "/admin"
end
