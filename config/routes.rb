Rails.application.routes.draw do
  root 'sessions#new'
  resources :registrations, only: [:new, :create]
end
