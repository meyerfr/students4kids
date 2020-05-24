Rails.application.routes.draw do
  # General Routes
  root to: 'pages#home'
  get 'corona', to: 'pages#corona', as: 'corona'

  # User Routes
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  resources :users, only: [:show, :edit, :update, :destroy]

  # Sitters Route
  get "sitters", to: "users#sitters", as: "sitters"

  # Booking Routes
  resources :bookings, only: [:index, :create]
  patch 'bookings/confirm/:id', to: 'bookings#confirm_booking', as: 'confirm_booking'
  patch 'bookings/decline/:id', to: 'bookings#decline_booking', as: 'decline_booking'

  # Availability Routes
  resources :availabilities, only: [:index, :create, :edit, :update, :destroy]
end
