class Question < ApplicationRecord
  # TODO change to db or enum?
  CATEGORIES = %w[housing employment family consumer other].freeze

  enum :status, { open: 0, answered: 1, closed: 2 }

  belongs_to :user
  has_many :answers, dependent: :destroy

  validates :title, :body, :category, :status, presence: true

  after_initialize :set_status_to_open, if: :new_record?

  private

  def set_status_to_open
    self.status = :open
  end
end
