Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
      namespace :v1 do

        get '/items/find', to: 'search#item_find'
        get '/items/find_all', to: 'search#item_find_all'
        get '/merchants/find', to: 'search#merchant_find'
        get '/merchants/find_all', to: 'search#merchant_find_all'

        resources :merchants

        resources :items

        get '/merchants/:merchant_id/items', to: 'merchant_items#index'

        get '/items/:id/merchant', to: 'items_merchant#show'
      end
    end
end
