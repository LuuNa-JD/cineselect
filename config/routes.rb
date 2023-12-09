Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "registrations" }
  root to: "pages#home"


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html


  resources :seances, only: [:new, :create, :index, :show]
  post '/favorites/toggle', to: 'favorites#toggle'
  resources :favorites, only: [:new, :create, :index, :destroy]
  resources :profiles, only: [:show]
  resources :user_platforms, only: [:new, :create, :destroy]
  get 'seances/:id/:type/streaming_platforms', to: 'seances#show_streaming_platforms', as: :streaming_platforms
  match '*path', to: 'errors#not_found', via: :all, constraints: lambda { |req| req.path.exclude? 'rails/active_storage' }
  get '/500', to: 'errors#internal_server_error', as: :internal_server_error
end
