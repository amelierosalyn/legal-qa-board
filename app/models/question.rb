class Question < ApplicationRecord
  # NOTE: Simplified for this exercise. In a production system, it would be better to
  # use a more robust solution for categories, such as a separate Category model or an enum
  # if these categories are fixed and known in advance.
  # For now, I am using a simple array of strings to represent the categories.
  CATEGORIES = %w[housing employment family consumer other].freeze

  enum :status, { open: 0, answered: 1, closed: 2 }

  attribute :status, default: "open"

  belongs_to :user
  has_many :answers, dependent: :destroy

  validates :title, :body, :category, :status, presence: true
  validates :category, inclusion: { in: CATEGORIES }

  def answers_pending?
    pending_answers_count.positive?
  end

  def pending_answers_count
    answers.joins(:payment_request).merge(PaymentRequest.pending).count
  end
end
