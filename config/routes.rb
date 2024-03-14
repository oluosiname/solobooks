# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users,
  path: '', # optional namespace or empty string for no space
  path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    password: 'password',
    confirmation: 'verification',
    # registration: 'register',
    sign_up: 'register',
  }
  # controllers: { registrations: 'registrations' }
  
  # Defines the root path route ("/")
  scope '(:locale)', locale: /en|de/ do
    root 'home#index'
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
