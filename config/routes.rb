Rails.application.routes.draw do
  resources :users, :only => [:index, :destroy] do
    member do
      patch :make_admin
      patch :make_non_admin
    end
  end
  resources :devices, :only => [:index, :new, :create, :destroy]
  resources :system_devices, :only => [:index, :new, :create, :destroy]

  root 'home#show'
  get '/login', to: 'sessions#new'
  get '/logout', to: 'sessions#destroy'
  get '/auth/:provider/callback', to: 'sessions#create'
  post '/auth/:provider/callback', to: 'sessions#create'
  get '/server_status', to: 'home#index'

  mount Geminabox::Server, :at => '/gems', :as => 'geminabox'
end
