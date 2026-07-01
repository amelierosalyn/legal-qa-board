class Question < ApplicationRecord
  # TODO change to db or enum?
  CATEGORIES = %w[housing employment family consumer other].freeze

  enum :status, { open: 0, answered: 1, closed: 2 }

  belongs_to :user
  has_many :answers, dependent: :destroy

  validates :title, :body, :category, :status, presence: true
  validates :category, inclusion: { in: CATEGORIES }

  after_initialize :set_status_to_open, if: :new_record?

  def answers_pending?
    pending_answers_count.positive?
  end

  def pending_answers_count
    answers.joins(:payment_request).merge(PaymentRequest.pending).count
  end

  private

  def set_status_to_open
    self.status = :open
  end
end
