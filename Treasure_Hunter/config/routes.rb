TreasureHunter::Application.routes.draw do

  devise_for :users

  resources :users
  resources :hunts
  resources :locations
  resources :clues

  root :to => 'hunts#index'

end
