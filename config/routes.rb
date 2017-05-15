Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  devise_scope :user do
    match '/users/sign_out', via: :options, to: 'sessions#options'
  end

  devise_for :users, controllers: {sessions: "sessions", registrations: "registrations", confirmations: "confirmations"}

  get 'test_locale', to: 'application#test_locale'
end
