Rails.application.routes.draw do
  devise_for :users, controllers: {sessions: "sessions", registrations: "registrations", confirmations: "confirmations"}

  match '*path', via: :options, to: 'application#options'

  resources :follows, only: [:create]
  delete '/follows/:followed_id', to: 'follows#destroy', as: 'destroy_follow'
  resources :likes, only: [:create]
  delete '/likes/:post_id', to: 'likes#destroy', as: 'destroy_like'
  resources :posts

  get 'test_locale', to: 'application#test_locale'

  resources :users, only: [:update, :show]
  resources :events, only: [:index] do
    resources :event_registrations, only: [:create, :index]
  end

  get '/users/:user_id/followers', to: 'follows#followers', as: 'followers'
  get '/users/:user_id/following', to: 'follows#following', as: 'following'
end
