# Mutations

## Mutation for creating blogs

Setting up mutations is as easy as queries, following a very similar process. All GraphQL mutations start from a root type called Mutation. This type is auto generated in the file `app/graphql/types/mutation_type.rb`.

The only difference is that we are going to create a new mutation class to define our mutation for creating blogs instead of adding it in the root type.

Create a new file `app/graphql/mutations/create_blog.rb`:

```
module Mutations
  class CreateBlog < BaseMutation
    argument :title, String, required: true
    argument :body, String, required: true

    type Types::BlogType

    def resolve(title:, body:)
      Blog.create!(
        title: title,
        body: body,
      )
    end
  end
end
```

Then, we have to expose this new mutation in the root type. If we don't do it, it won't be available in the schema.

Add this in `app/graphql/types/mutation_type.rb`:

```
module Types
  class MutationType < BaseObject
    field :create_blog, mutation: Mutations::CreateBlog, description: 'Create new blog'
  end
end
```

To test it, just restart the server and use GrpahiQL.

## Extra mile

What if creating a blog implies sending a lot of params? Is there a way to refactor this mutation? Or should we still send them separate and catch them one by one using keyword arguments?
