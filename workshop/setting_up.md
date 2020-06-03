# Setting up

## Prerequisites

First, you’ll need to have Ruby installed on your system. If that’s not the case, make sure to install it now. This workshop requires version 2.5.0 or higher.

Then, check you also installed Bundler and Rails. You'll need version 6.0.2.2 of Rails.

## Create Rails application

To create the Rails app we're going to use the Rails generator with some specific configurations:

```ruby
rails new graphql-workshop --api -T -d postgresql
```

We'll be using PostgreSQL for the database and RSpec for the testing suite.

Finally, after running:

```ruby
cd graphql-workshop
bundle exec rails db:create
bundle exec rails server
```

When you visit http://localhost:3000 in a browser, you should see the Rails welcome page.

## Setup GraphQL

Now, let's add GraphQL to our server.

We're going to add new gems to the app so first, stop the server.

Add the following dependency in your `Gemfile`:

```ruby
gem 'graphql', '1.9.17'
```

Then run:

```ruby
bundle install
bundle exec rails generate graphql:install
```

This will setup GraphQL in our API.

Finally, let's add another dependency which we'll use later as a playground for our project. Add the following to the `Gemfile`:

```ruby
gem 'graphiql-rails', '1.7.0', group: :development
```

And then run:

```ruby
bundle install
```

Since this is an API, we have to make some changes to make it work.

First, your `config/application.rb` might look like:

```ruby
...
require 'sprockets/railtie'
...

module MyApi
  class Application < Rails::Application
    ...
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Session::CookieStore
    config.middleware.use Rack::MethodOverride
    config.middleware.use ActionDispatch::Flash
  end
end
```

And your `app/controllers/application_controller.rb` must inherit from `ActionController::Base`:

```ruby
class ApplicationController < ActionController::Base
  ...
end
```

We also have to add a new file `app/assets/config/manifest.js` with the following:

```ruby
//= link graphiql/rails/application.css
//= link graphiql/rails/application.js
```

Finally, define a new route in `config/routes.rb`:

```ruby
...
if Rails.env.development?
  mount GraphiQL::Rails::Engine, at: '/graphiql', graphql_path: '/graphql'
end
...
```

GraphiQL setup is ready. Restart your sever and visit http://localhost:3000/graphiql in a browser, you should see GraphiQL up and running.

We'are now ready to start building our API using GraphQL.

## Necessary gems

Users will have an encrypted password which requires `bcrypt` gem.

Add the following line to your `Gemfile`:

```ruby
gem 'bcrypt', '~> 3.1.13'
```

Then run:
```ruby
bundle install
```

## Setup models

First, we will need to create the necessary models for this blogging application and their tables in the database:

```ruby
bundle exec rails generate model User first_name:string last_name:string email:string auth_token:token password_digest
bundle exec rails generate model Blog title:string body:text user:references
bundle exec rails db:migrate
```

Be sure your models look like this:

```ruby
class User < ApplicationRecord
  has_secure_password
  has_secure_token :auth_token

  validates :first_name, :last_name, presence: true
  validates :email, presence: true, uniqueness: true

  has_many :blogs, dependent: :destroy
end
```
```ruby
class Blog < ApplicationRecord
  validates :title, :body, presence: true

  belongs_to :user
end
```

Before moving on, let's create some dummy records:

```ruby
bundle exec rails console
user = User.create email: 'vamoeh@xmartlabs.com', first_name: 'Matias', last_name: 'Irland', password: 'changeme'
Blog.create title: 'Android sucks', body: 'After some years being part of the Android team, I want to learn Ruby.', user: user
Blog.create title: 'Ruby is the best', body: "I've just finished a Ruby training course and I can tell you it is awesome.", user: user
```
