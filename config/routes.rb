# config/routes.rb
Rails.application.routes.draw do
  resources :tenho_sokais, only: [:index, :show] do
    collection do
      get 'search'
    end
  end

  root to: 'tenho_sokais#search'
end
