Rails.application.routes.draw do
  root 'home#index'

  namespace :api, {format: 'json'} do
    namespace :v1 do
      resources :groups, only: [:index, :create, :update, :destroy] do
        resources :messages, only: [:create]
      end
    end
  end
end
