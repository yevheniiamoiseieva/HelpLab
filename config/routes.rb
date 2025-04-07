Rails.application.routes.draw do

  root to: "home#index"
  get 'dashboard', to: 'home#dashboard', as: :dashboard

  get "service-worker" => "rails/pwa#service_worker"
  get "manifest" => "rails/pwa#manifest"

  get "up" => "rails/health#show"
  devise_for :users, controllers: {
    confirmations: 'users/confirmations',
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  }
  devise_scope :user do
    get '/users/sign_out', to: 'devise/sessions#destroy', as: :custom_destroy_user_session
  end
  resources :users, only: []
end