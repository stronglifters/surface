Rails.application.routes.draw do
  root 'sessions#new'
  resources :sessions, only: [:new, :destroy]
  resources :registrations, only: [:new, :create]
  get '/' => 'sessions#new', as: :dashboard
  get "/terms" => "static_pages#terms"
end
