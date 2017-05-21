Rails.application.routes.draw do

  match '*path', via: :options, to: 'application#options'

  resources :follows, only: [:create]
  delete '/follows/:followed_id', to: 'follows#destroy', as: 'destroy_follow'
  resources :likes, only: [:create]
  delete '/likes/:post_id', to: 'likes#destroy', as: 'destroy_like'
  resources :users, only: [:update]
  resources :posts

  get 'test_locale', to: 'application#test_locale'

  devise_for :users, controllers: {sessions: "sessions", registrations: "registrations", confirmations: "confirmations"}
end
