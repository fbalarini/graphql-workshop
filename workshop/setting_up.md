# Setting up

## Prerequisites

First, you’ll need to have Ruby installed on your system. If that’s not the case, make sure to install it now. This workshop requires version 2.5.0 or higher.

Then, check you also installed Bundler and Rails. You'll need version 6.0.2.2 of Rails.

## Create Rails application

To create the Rails app we're going to use the Rails generator with some specific configurations:

```
rails new graphql-workshop --api -T -d postgresql
```

We'll be using PostgreSQL for the database and RSpec for the testing suite.

Finally, after running:

```
cd graphql-workshop
bundle exec rails db:create
bundle exec rails server
```

When you visit http://localhost:3000 in a browser, you should see the Rails welcome page.

## Setup GraphQL

Now, let's add GraphQL to our server.

We're going to add new gems to the app so first, stop the server.

Add the following dependency in your `Gemfile`:

```
gem 'graphql', '1.9.17'
```

Then run:

```
bundle install
bundle exec rails generate graphql:install
```

This will setup GraphQL in our API.

Finally, let's add another dependency which we'll use later as a playground for our project. Add the following to the `Gemfile`:

```
gem 'graphiql-rails', '1.7.0', group: :development
```

And then run:

```
bundle install
```

We'are now ready to start building our API using GraphQL.
