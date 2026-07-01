class User < ApplicationRecord
  enum :role, { client: 0, lawyer: 1, admin: 2 }

  has_many :questions, dependent: :destroy
  has_many :answers, foreign_key: :lawyer_id, dependent: :destroy

  validates :name, :email, :role, presence: true
  validates :email, uniqueness: true
end
