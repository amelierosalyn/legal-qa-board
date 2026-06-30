class PaymentRequest < ApplicationRecord
  enum :status, { pending: 0, approved: 1, rejected: 2 }

  belongs_to :answer

  validates :status, presence: true

  def approve!
    transaction do
      approved!
      answer.update!(paid: true)
      answer.question.answered!
    end
  end
end