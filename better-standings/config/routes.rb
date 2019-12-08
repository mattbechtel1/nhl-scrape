Rails.application.routes.draw do
  resources :players
  resources :games
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :conferences, only: [:show, :index]
  resources :teams, only: :show
end
