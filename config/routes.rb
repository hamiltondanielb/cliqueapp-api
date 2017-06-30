Rails.application.routes.draw do
  delete '/users', to: 'users#destroy'

  devise_for :users, controllers: {sessions: "sessions", registrations: "registrations", confirmations: "confirmations"}

  match '*path', via: :options, to: 'application#options'

  resources :follows, only: [:create]

  delete '/follows/:followed_id', to: 'follows#destroy', as: 'destroy_follow'

  resources :likes, only: [:create]

  delete '/likes/:post_id', to: 'likes#destroy', as: 'destroy_like'

  resources :posts

  get 'test_locale', to: 'application#test_locale'

  resources :users, only: [:update, :show, :destroy]

  post '/users/connect_stripe', to: 'users#connect_stripe', as: 'connect_stripe'
  post '/users/disconnect_stripe', to: 'users#disconnect_stripe', as: 'disconnect_stripe'

  get '/events/days_with_events', to: 'events#days_with_events', as: 'days_with_events'
  get '/events/days_with_following_events', to: 'events#days_with_following_events', as: 'days_with_following_events'
  get '/events/days_with_event_registrations', to: 'event_registrations#days_with_event_registrations', as: 'days_with_event_registrations'

  get '/events/following', to: 'events#following_events', as: 'following_events'

  resources :events, only: [:index, :destroy] do
    resources :event_registrations, only: [:create]
  end

  resources :event_registrations, only: [:index]

  delete '/events/:event_id/event_registrations', to: 'event_registrations#destroy', as: 'event_registration'

  get '/users/:user_id/followers', to: 'follows#followers', as: 'followers'
  get '/users/:user_id/following', to: 'follows#following', as: 'following'

  get '/search/users', to: 'searches#user_search', as: 'user_search'
  get '/search/events', to: 'searches#event_search', as: 'event_search'

  resources :articles

   get '/geo_ip_request/', to: "geo_ip_request#users_ip"
end
