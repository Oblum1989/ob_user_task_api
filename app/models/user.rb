class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true
  validates :full_name, presence: true
  validates :role, presence: true

  enum :role, { admin: 0, user: 1, guest: 2 }
end
