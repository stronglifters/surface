Rails.application.routes.draw do

  root 'sessions#new'
  resources :sessions, only: [:new, :create, :destroy]
  resources :registrations, only: [:new, :create]
  resources :items
  get '/' => 'sessions#new', as: :dashboard
  get "/terms" => "static_pages#terms"
end
