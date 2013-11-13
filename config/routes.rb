TreasureHunter::Application.routes.draw do

  post "hunt_users", to: 'hunt_users#create'

  get "user/:username", to: 'users#show'

  post "hunt_locations", to: 'hunt_locations#create'

  devise_for :users

  resources :users, except: [:show]
  resources :hunts
  resources :locations
  resources :clues

  root :to => 'hunts#index'

end
