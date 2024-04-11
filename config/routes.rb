# frozen_string_literal: true

Rails.application.routes.draw do
  # Defines the root path route ("/")
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  scope '(:locale)', locale: /en|de/ do
    devise_for :users,
      path: '', # optional namespace or empty string for no space
      path_names: {
        sign_in: 'login',
        sign_out: 'logout',
        password: 'password',
        confirmation: 'verification',
        # registration: 'register',
        sign_up: 'register',
      },
    controllers: { confirmations: 'users/confirmations' }

    root 'home#index'

    resources :invoices, only: [:new, :create, :index]
    resources :invoice_categories, only: [:new, :create]
    resources :clients, only: [:new, :create, :index]
    resource :profile, only: [:show, :update]
    post :profile, to: 'profiles#create', as: :create_profile
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
