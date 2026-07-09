class User < ApplicationRecord
  has_secure_password

  # has_one :onboarding, dependent: :destroy

  enum :role, {
    customer: 0,
    admin: 1
  }

  validates :email, presence: true, uniqueness: true
end
