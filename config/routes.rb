Rails.application.routes.draw do
  # General Routes
  root to: 'pages#home'
  get 'corona', to: 'pages#corona', as: 'corona'

  # User Routes
  devise_for :users
  resources :users

  # Booking Routes
  resources :bookings, only: [:index, :new, :create, :destroy]
  get 'bookings/confirm/:id', to: 'bookings#confirm_booking', as: 'confirm_booking'
  get 'bookings/decline/:id', to: 'bookings#decline_booking', as: 'decline_booking'

  # Availability Routes
  resources :availabilities, only: [:index, :create, :edit, :update, :destroy]
end
