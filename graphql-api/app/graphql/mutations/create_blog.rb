module Mutations
  class CreateBlog < GraphQL::Schema::Mutation
    argument :email, String, required: true, description: "Author's email"
    argument :title, String, required: true
    argument :body, String, required: true

    type Types::BlogType

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
