Rails.application.routes.draw do

  get 'admin', :to => 'index#home'

  root 'index#home'

  get "calc/input", to: "calc#input"

  get "game/new/:id/:forecast", to: "game#new"

  match ':controller(/:action(/:id))', :via => [:get, :post]

  resources :products do
    resources :reviews
  end
  
end
