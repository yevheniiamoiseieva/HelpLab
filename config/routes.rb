Rails.application.routes.draw do
  # Главная страница — лента запросов
  get "feed/index"
  root "feed#index"

  # Дашборд
  get 'dashboard', to: 'home#dashboard', as: :dashboard

  # Devise: регистрация, вход, подтверждение и пр.
  devise_for :users, controllers: {
    confirmations: 'users/confirmations',
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  }

  devise_scope :user do
    get '/users/sign_out', to: 'devise/sessions#destroy', as: :custom_destroy_user_session
  end

  # Профіль поточного користувача
  resource :profile, only: [:show, :edit, :update]

  # Профіль іншого користувача (для чату або перегляду)
  get '/profiles/:id', to: 'profiles#public_show', as: 'public_profile'

  # Відгуки про користувачів
  resources :users, only: [] do
    resources :reviews, only: [:new, :create]
  end

  # Запити, відповіді і чат
  resources :requests do
    resources :responses, only: [:create]
    resources :messages, only: [:index, :create]

    member do
      patch :complete  # Завершення запиту
    end
  end

  resources :users, only: [] do
    resources :reviews, only: [:new, :create]
  end

  # Уведомления
  resources :notifications, only: [:index]

  # PWA / System / Health
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  get "service-worker" => "rails/pwa#service_worker"
  get "manifest" => "rails/pwa#manifest"
  get "up" => "rails/health#show"
end
