module Types
  class MutationType < Types::BaseObject
    field :create_blog, mutation: Mutations::CreateBlog, description: 'Create new blog'
    field :sign_in, mutation: Mutations::SignIn, description: 'Sign in user'
  end
end
