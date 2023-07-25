Rails.application.routes.draw do
  resources :tenho_sokais, only: [:index, :create, :show] do
    collection do
      get 'search'
    end
  end
  root to: "tenho_sokais#index"
end
