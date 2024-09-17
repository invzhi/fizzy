Rails.application.routes.draw do
  root "bubbles#index"

  resource :session

  resources :projects do
    resources :users, controller: "projects/users"
  end

  resources :bubbles do
    resource :image, controller: "bubbles/images"

    resources :assignments
    resources :boosts
    resources :comments
    resources :tags, shallow: true
  end

  resources :tags, only: :index

  get "up", to: "rails/health#show", as: :rails_health_check
end
