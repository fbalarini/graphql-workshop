module Types
  class MutationType < Types::BaseObject
    field :create_blog, mutation: Mutations::CreateBlog, description: 'Create new blog'
  end
end
