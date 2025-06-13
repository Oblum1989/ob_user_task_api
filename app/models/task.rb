class Task < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :description, presence: true
  validates :status, presence: true
  validates :due_date, presence: true
  validates :user_id, presence: true

  enum :status, { pending: 0, completed: 1, expired: 2, archived: 3 }
end
