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
  get '/events/days_with_activity', to: 'events#days_with_activity', as: 'days_with_activity'
  resources :events, only: [:index] do
    resources :event_registrations, only: [:create]
  end
  resources :event_registrations, only: [:index]
  delete '/events/:event_id/event_registrations', to: 'event_registrations#destroy', as: 'event_registration'

  get '/users/:user_id/followers', to: 'follows#followers', as: 'followers'
  get '/users/:user_id/following', to: 'follows#following', as: 'following'
end
