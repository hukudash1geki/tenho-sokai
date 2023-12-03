# config/routes.rb
Rails.application.routes.draw do
  resources :tenho_sokais, only: [:index, :show] do
    collection do
      get 'search'
    end
    member do
      get 'show_another'
    end
  end

  root to: 'tenho_sokais#index'
end