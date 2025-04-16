Rails.application.routes.draw do
  # Главная страница — лента запросов
  get "feed/index"
  root "feed#index"
  post '/become_volunteer', to: 'feed#become_volunteer', as: :become_volunteer

  get 'dashboard', to: 'home#dashboard', as: :dashboard
  get '/about', to: 'feed#about', as: 'about'

  devise_for :users, controllers: {
    confirmations: 'users/confirmations',
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  }

  devise_scope :user do
    get '/users/sign_out', to: 'devise/sessions#destroy', as: :custom_destroy_user_session
  end

  resource :profile, only: [:show, :edit, :update]

  get '/profiles/:id', to: 'profiles#public_show', as: 'public_profile'

  resources :users, only: [] do
    resources :reviews, only: [:new, :create]
  end

  resources :requests do
    resources :responses, only: [:create]
    resources :messages, only: [:index, :create]

    member do
      patch :complete
      patch :revert
    end
  end

  resources :users, only: [] do
    resources :reviews, only: [:new, :create]
  end

  resources :notifications, only: [:index]

  # Волонтёрский раздел (Мої чати и список откликов)
  namespace :volunteer do
    resources :chats, only: [:index, :show]
    resources :responses, only: [:index, :show]
  end

  # PWA / System / Health
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  get "service-worker" => "rails/pwa#service_worker"
  get "manifest" => "rails/pwa#manifest"
  get "up" => "rails/health#show"
end
