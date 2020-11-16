Rails.application.routes.draw do
  root 'home#index'

  namespace :api, {format: 'json'} do
    namespace :v1 do
      resources :groups, only: [:index, :create]
    end
  end
end
