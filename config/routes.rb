Rails.application.routes.draw do
  resources :pokemons
    resource :users, only: [:create]
    post "/login", to: "users#login"
end
