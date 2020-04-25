Rails.application.routes.draw do
  root to: "pages#home"
  get "corona", to: "pages#corona", as: "corona"

  devise_for :users

  resources :bookings
  resources :availabilities
  resources :users
end
