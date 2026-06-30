class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :lawyer, class_name: "User"
  has_one :payment_request, dependent: :destroy

  validates :response_text, presence: true
  validates :proposed_fee_pence, numericality: { greater_than: 0 }

  after_create :create_pending_payment_request

  def fee_in_pounds
    proposed_fee_pence / 100.0
  end

  private

  def create_pending_payment_request
    create_payment_request!(status: :pending)
  end
end
