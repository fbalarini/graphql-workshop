class User < ApplicationRecord
  has_secure_password
  has_secure_token :auth_token

  validates :first_name, :last_name, presence: true
  validates :email, presence: true, uniqueness: true

  has_many :blogs, dependent: :destroy
end
