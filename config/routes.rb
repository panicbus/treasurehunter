TreasureHunter::Application.routes.draw do

  post "hunt_locations", to: 'hunt_locations#create'

  post "hunt_users", to: "hunt_users#create"
  post "hunt_users/:id/confirm", to: "hunt_users#confirm_participation"

  get "hunt_users/:id/:hunt_id/store_hunter", to: "hunt_users#store_hunter"

  get "user/:username", to: 'users#show'

  devise_for :users

  resources :users, except: [:show]
  resources :hunts
  resources :locations
  resources :clues

  root :to => 'hunts#index'

end
