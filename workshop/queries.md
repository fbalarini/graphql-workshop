# Queries

## Query to return blogs

In this section, we'll start building our GraphQL API. First, we need a query to show all the available blogs.

Run the following command:

```ruby
rails g graphql:object BlogType id:ID! title:String! body:String!
```

This creates the file `app/graphql/types/blog_type.rb`.

Now, let's create our first query resolver to return the dummy blogs we've created.

All GraphQL queries start from a root type called Query. When we ran `rails generate graphql:install`, it created the root query type in `app/graphql/types/query_type.rb`.

Update its content:

```ruby
module Types
  class QueryType < BaseObject
    field :all_blogs, [BlogType], null: false, description: 'Return all the blogs'

    # This method is invoked, when `all_blogs` fields is being resolved
    def all_blogs
      Blog.all
    end
  end
end
```

To check it is working, we're going to use the playground provided by GraphQL by default called GraphiQL, an in-browser IDE.

Open your browser at http://localhost:3000/graphiql

Try it out!

## Extra mile

What if we want to return the author of each blog?
