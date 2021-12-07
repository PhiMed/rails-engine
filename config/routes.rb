Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
      namespace :v1 do
        resources :merchants

        get '/merchants/:merchant_id/items', to: 'merchant_items#index'

        resources :items

        get '/search', to: 'search#show'

      end
    end
end
