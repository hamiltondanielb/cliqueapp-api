source 'https://rubygems.org'
ruby '2.4.1'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'haml-rails'
gem 'newrelic_rpm'
gem 'factory_girl_rails', groups: [:development, :test]
gem 'dotenv-rails', groups: [:development, :test]
gem 'simplecov', :require => false, :group => :test
gem 'stripe'
gem 'aws-sdk', group: :production
gem 'acts-as-taggable-on', '~> 4.0'
gem "paperclip", "~> 5.0.0"
gem 'paperclip-av-transcoder'
gem 'rack-cors'
gem 'pry-rails'
gem 'pry-nav'
gem 'pry-rescue'
gem 'devise', :git => 'https://github.com/plataformatec/devise.git'
gem 'devise-jwt'
gem 'minitest', "5.10.1", group: [:test]  # unpin next time rails is updated
gem 'minitest-ci', group: [:test]
gem 'rails', '~> 5.1.0'
gem 'sqlite3', group: [:development, :test]
gem 'pg'
gem 'pg_search'
gem 'kaminari'
gem 'puma', '~> 3.7'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'active_model_serializers', '~> 0.10.0'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'capybara', '~> 2.13.0'
  gem 'selenium-webdriver'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
