# Install

- Install ruby
- Install bundler: `gem install bundler`
- Run `bundle install`

The above will install all the dependencies required by the app.

- Run `rails db:migrate`

The above will prepare the database tables required by the app.

You will also need to generate a secret for generating authentication tokens:

    echo DEVISE_JWT_SECRET_KEY=$(rake secret) > .env.local


# Run


You can start the server by running `rails s`. If you want to run the API on a different port (e.g. 4444), you can run:

    rails s -p 4444


# Test

To run tests, just run:

    rails test


# Deploy

To deploy the app, make sure you created a Heroku remote pointing to the environment you want to deploy to.

You will need to install the [Heroku toolbelt](https://devcenter.heroku.com/articles/heroku-cli).

Here's an example of creating a `staging` remote:

    heroku create --remote staging open-lesson-api-staging

Once that's done, you can push to staging like so:

    git push staging
