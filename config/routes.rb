require 'sidekiq/web'
Rails.application.routes.draw do
  # enable sidekiq gui background jobs
  mount Sidekiq::Web => '/sidekiq'

  root to: 'home#index'

  resources :imports, only: [ :index ] do
    collection do
      get 'import_product'
      get 'import_in_transit'
      get 'import_on_hand'
      post 'import'
    end
  end
end
