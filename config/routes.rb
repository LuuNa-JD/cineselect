Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "registrations" }
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :seances, only: [:new, :create, :index, :show]
  post '/favorites/toggle', to: 'favorites#toggle'
  resources :favorites, only: [:new, :create, :index, :destroy]
  resources :profiles, only: [:show]
  resources :user_platforms, only: [:new, :create, :destroy]
  get 'seances/:id/:type/streaming_platforms', to: 'seances#show_streaming_platforms', as: :streaming_platforms
end
