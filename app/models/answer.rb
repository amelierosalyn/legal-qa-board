class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :lawyer, class_name: "User"
  has_one :payment_request, dependent: :destroy

  validates :response_text, presence: true
  validates :proposed_fee_pence, numericality: { greater_than: 0 }

  attr_writer :proposed_fee_pounds

  before_validation :convert_pounds_to_pence
  after_create :create_pending_payment_request

  def fee_in_pounds
    proposed_fee_pence / 100.0
  end

  def proposed_fee_pounds
    return @proposed_fee_pounds if @proposed_fee_pounds.present?
    proposed_fee_pence ? proposed_fee_pence / 100.0 : nil
  end

  def self.pending_payment_request_count
    joins(:payment_request).merge(PaymentRequest.pending).count
  end

  private

  def convert_pounds_to_pence
    if @proposed_fee_pounds.present?
      self.proposed_fee_pence = (@proposed_fee_pounds.to_d * 100).round
    end
  end

  def create_pending_payment_request
    create_payment_request!(status: :pending)
  end
end
