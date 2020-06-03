module Types
  class QueryType < Types::BaseObject
    field :all_blogs, [BlogType], null: false, description: 'Return all the blogs'

    # This method is invoked, when `all_blogs` fields is being resolved
    def all_blogs
      Blog.all
    end
  end
end
