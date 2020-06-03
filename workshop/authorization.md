# Authorization

While a query is running, you can check if the current user is authorized to query that data. If the user is not authorized, you can handle the case with an error.

## Admin users

Let's add a simple boolean in the user's model which indicates if the user is an administrator or not.

```ruby
bundle exec rails generate migration AddAdminToUsers admin:boolean
```

We want this admin flag to be false as default, add this to the migration:

```ruby
class AddAdminToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :admin, :boolean, default: false
  end
end
```

Then run:

```ruby
bundle exec rails db:migrate
```

Let's check our dummy user is not an admin:

```ruby
bundle exec rails console
User.first.admin # -> false
```

Then create another user:

```ruby
User.create email: 'admin@xmartlabs.com', first_name: 'Administrator', last_name: 'XL', password: 'changeme', admin: true
```

And finally one dummy blog for that new user:

```ruby
Blog.create title: 'Dummy blog', body: 'I have no idea on how to write a blog.', user: User.find_by(email: 'admin@xmartlabs.com')
```

## Creating blogs

Since we have everything setup to have administrators, we are going to restrict the creation of blogs and only them will be able to create new blogs.

Let's change the mutation:

```ruby
module Mutations
  class CreateBlog < BaseMutation
    argument :email, String, required: true, description: "Author's email"
    argument :title, String, required: true
    argument :body, String, required: true

    type Types::BlogType

    def ready?(**_args)
      context[:current_user].admin
    end

    def resolve(email:, title:, body:)
      user = User.find_by(email: email)
      return unless user

      Blog.create!(
        title: title,
        body: body,
        user: user
      )
    end
  end
end
```

When `ready?` returns false (or something falsey), the mutation will be halted. If it returns true (or something truthy), the mutation will continue.

Knowing that, we can add errors to the `errors` key when the user is not authorized to perform an action.

```ruby
module Mutations
  class CreateBlog < BaseMutation
    ...
    def ready?(**_args)
      context[:current_user].admin || raise(GraphQL::ExecutionError, "You can't create new blogs")
    end
    ...
  end
end
```

Try it out using Postman!
