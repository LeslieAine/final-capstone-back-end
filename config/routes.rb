Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: [:index, :show, :create]
      get 'houses/index'
      post 'houses/create', to: 'houses#create'
      get 'houses/:id', to: 'houses#show'
      delete 'houses/delete/:id', to: 'houses#destroy'
    end
  end
end
