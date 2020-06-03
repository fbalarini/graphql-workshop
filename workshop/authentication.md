# Authentication

## Sign in

First of all, as we do with blgos, let's create the `UserType`:

```
rails g graphql:object UserType id:ID! email:String! first_name:String! last_name:String!
```

This creates the file `app/graphql/types/user_type.rb`.

Signing users in will be as simple as verifying the email and password and returning a token that can be used in subsequent requests.

The steps to add this new mutation would be very similar to the ones we added before.

First, create a resolver for the sign in mutation:
```
module Mutations
  class SignIn < BaseMutation
    argument :email, String, required: true
    argument :password, String, required: true

    field :user, Types::UserType, null: true
    field :token, String, null: true

    def resolve(email:, password:)
      user = User.find_by(email: email)

      return unless user
      return unless user.authenticate(password)

      { user: user, token: user.auth_token }
    end
  end
end
```

Let's expose it:
```
module Types
  class MutationType < BaseObject
    field :create_blog, mutation: Mutations::CreateBlog, description: 'Create new blog'
    field :sign_in, mutation: Mutations::SignIn, description: 'Sign in user'
  end
end
```

As we did with the other queries and mutations, you can try it out using GraphiQL.

## Authenticating requests

Now we can authenticate subsequent requests. The GraphQL server should be able to get the token from the headers on each request, detect what user it relates to, and pass this information down to the mutations.

The best way to pass information down to the mutations is using the context object.

We'll have to change the `app/controllers/graphql_controller.rb` and update the context:

```
class GraphqlController < ApplicationController
  def execute
    variables = ensure_hash(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]
    result = GraphqlWorkshopSchema.execute(query, variables: variables, context: context, operation_name: operation_name)
    render json: result
  rescue => e
    raise e unless Rails.env.development?
    handle_error_in_development e
  end

  private

  def context
    {
      current_user: current_user
    }
  end

  def current_user
    User.find_by(auth_token: request.headers['AuthToken'])
  end
```

We're now ready to authenticate the query we built before.

## Authenticating blogs query

We need to handle the context inside the query in order to check the request being done is authenticated.

Add the following to `app/graphql/types/query_type.rb`:
```
module Types
  class QueryType < BaseObject
    field :all_blogs, [BlogType], null: false, description: 'Return all the blogs'

    # This method is invoked, when `all_blogs` fields is being resolved
    def all_blogs
      raise GraphQL::ExecutionError, 'Can't continue with this query' unless context[:current_user]

      Blog.all
    end
  end
end
```

When a `GraphQL::ExecutionError` is raised, GraphQL-Ruby rescues it. Its message will be added to the `errors` key and GraphQL-Ruby will automatically add the line, column and path to it.

The error might look like:
```
{
  "errors" => [
    {
      "message" => "Can't continue with this query",
      "locations" => [
        {
          "line" => X,
          "column" => Y,
        }
      ],
      "path" => ["user", "sigIn"],
    }
  ]
}
```

To try it out we're going to stop using GraphiQL because it doesn't have support to add new headers to the requests.

Postman is a good option too, let's check it out in this [link](https://learning.postman.com/docs/postman/sending-api-requests/graphql/).

## Extra mile

The way we built it, the authentication token is returned as part of the GraphQL response, in the `data` key. If we want to return the auth token as part of the response headers, can we? How would it be?
