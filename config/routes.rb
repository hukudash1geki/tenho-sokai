Rails.application.routes.draw do
  resources :tenho_sokais
  root to: "tenho_sokais#index"
end
