module Mutations
  class SignIn < GraphQL::Schema::Mutation
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
