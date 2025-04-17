Rails.application.routes.draw do
  # Главная страница — лента запросов
  get "feed/index"
  root "feed#index"
  post "/become_volunteer", to: "feed#become_volunteer", as: :become_volunteer

  get "dashboard", to: "home#dashboard", as: :dashboard
  get "/about", to: "feed#about", as: "about"

  devise_for :users, controllers: {
    confirmations: "users/confirmations",
    registrations: "users/registrations",
    passwords: "users/passwords"
  }

  devise_scope :user do
    get "/users/sign_out", to: "devise/sessions#destroy", as: :custom_destroy_user_session
  end

  resource :profile, only: [ :show, :edit, :update ]

  get "/profiles/:id", to: "profiles#public_show", as: "public_profile"

  resources :users, only: [ :index, :show ] do
    resources :reviews, only: [ :new, :create ]  # Оставляем один блок
  end

  resources :requests do
    resources :responses, only: [ :create ]  # добавляем отклики
    resources :messages, only: [ :index, :create ]  # добавляем сообщения

    member do
      patch :complete   # отметить запрос как завершённый
      patch :revert     # вернуть запрос в статус "в процессе"
    end
  end

  resources :notifications, only: [ :index ]  # уведомления

  # Волонтёрский раздел (Мої чати и список откликов)
  namespace :volunteer do
    resources :chats, only: [ :index, :show ]  # чаты волонтёра
    resources :responses, only: [ :index, :show ]  # отклики волонтёра
  end

  # PWA / System / Health
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  get "service-worker" => "rails/pwa#service_worker"
  get "manifest" => "rails/pwa#manifest"
  get "up" => "rails/health#show"
end
