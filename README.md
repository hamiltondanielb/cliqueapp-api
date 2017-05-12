# How To Run Locally


- Install ruby
- Install bundler: `gem install bundler`
- Run `bundle install`
- Run `rails db:migrate`
- Generate secrets: `echo DEVISE_JWT_SECRET_KEY=$(rake secret) > .env.local`
- Start the server: `rails server`


