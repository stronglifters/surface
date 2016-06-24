Rails.application.routes.draw do
  root "sessions#new"
  resources :sessions, only: [:new, :create, :destroy]
  resources :registrations, only: [:new, :create]
  resources :exercise_sets, only: [:update]
  resources :training_sessions, only: [:index, :new, :create, :edit]
  resources :programs, only: [:show]
  resources :profiles, only: [:new, :create, :show, :edit, :update], constraints: { id: /[^\/]+/ }
  resources :gyms, only: [:index, :show, :new, :create]
  get "/u/:id" => "profiles#show", constraints: { id: /[^\/]+/ }
  get "/dashboard" => "training_sessions#index", as: :dashboard
  get "/terms" => "static_pages#terms"
  get "/stronglifts/export" => "static_pages#export"

  get "/email/incoming", to: proc { [200, {}, ["OK"]] }
  post "/email/incoming" => "griddler/emails#create"
end
