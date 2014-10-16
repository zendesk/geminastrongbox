Rails.application.routes.draw do
  resources :devices, :only => [:index, :new, :create, :destroy]

  root 'home#show'
  get '/login', to: 'sessions#new'
  get '/logout', to: 'sessions#destroy'
  get '/auth/:provider/callback', to: 'sessions#create'
  post '/auth/:provider/callback', to: 'sessions#create'

  mount Geminabox::Server, :at => '/gems'
end
