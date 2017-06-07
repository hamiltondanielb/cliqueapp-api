# Install

- Install ruby
- Install bundler: `gem install bundler`
- Run `bundle install`

The above will install all the dependencies required by the app.

- Run `rails db:migrate`

The above will prepare the database tables required by the app.

You will also need to generate a secret for generating authentication tokens:

    echo DEVISE_JWT_SECRET_KEY=$(rake secret) > .env


## Database Migrations

In order to run the app, you will need to apply database migrations. You will need to do this once in the beginning but also as you go, if you pull down new database migrations from the repository. To update your development database, you can run:

    rails db:migrate

## Image Magick

To process uploads, you will need Image Magick installed. You should run the following command:

    brew install imagemagick

# Run


You can start the server by running `rails s`. If you want to run the API on a different port (e.g. 4444), you can run:

    rails s -p 4444


In order to get all the features, you will need a few environment variables. Store the following in a file called `.env`:

```
DEVISE_JWT_SECRET_KEY=36fb2d3ad966bf8f75dddc1f4a1a5e6ed37ecdceea5461e0d9e2c25c80bc497aa9f576b2d0cc95e5a49e8ba7b67ccaa6c907e91610c56389969e30539659c696
STRIPE_KEY=sk_test_SlTDoD7uUc3WUf2f94AphJGB
APP_URL="http://localhost:3000"
```

And then restart the Rails server. The `dotenv` gem should pick up these environment variables automatically.

It would be best if you used your own secret and Stripe key.

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

# FAQ

#### If you're getting errors saying `SQLite3::BusyException: database is locked`, you should try running the server like so:

    RAILS_MAX_THREADS=1 rails s -p 4444

#### If you want to access the app on your phone, you will have to bind the rails server to the external interface like so:

    rails s -p 4444 -b 0.0.0.0
