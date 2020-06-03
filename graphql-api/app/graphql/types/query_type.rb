module Types
  class QueryType < Types::BaseObject
    field :all_blogs, [BlogType], null: false, description: 'Return all the blogs'

    # This method is invoked, when `all_blogs` fields is being resolved
    def all_blogs
      raise GraphQL::ExecutionError, "Can't continue with this query" unless context[:current_user]

      Blog.all
    end
  end
end
