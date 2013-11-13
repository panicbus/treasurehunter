TreasureHunter::Application.routes.draw do

  post "hunt_locations", to: 'hunt_locations#create'

  devise_for :users

  resources :users
  resources :hunts
  resources :locations
  resources :clues

  root :to => 'hunts#index'

end
