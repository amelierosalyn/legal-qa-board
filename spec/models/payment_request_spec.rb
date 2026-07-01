require "rails_helper"

RSpec.describe PaymentRequest, type: :model do
  subject(:payment_request) do
    FactoryBot.build(
      :payment_request,
      answer: FactoryBot.create(
        :answer,
        question: FactoryBot.create(:question, user: FactoryBot.create(:user, email: "client@example.com")),
        lawyer: FactoryBot.create(:user, role: :lawyer, email: "lawyer@example.com")
      ),
      status: :pending
    )
  end

  it { is_expected.to belong_to(:answer) }
  it { is_expected.to validate_presence_of(:status) }

  it "approves the payment, marks the answer paid, and closes the question" do
    payment_request = FactoryBot.create(
      :payment_request,
      answer: FactoryBot.create(
        :answer,
        question: FactoryBot.create(:question, user: FactoryBot.create(:user, email: "client@example.com")),
        lawyer: FactoryBot.create(:user, role: :lawyer, email: "lawyer@example.com")
      ),
      status: :pending
    )

    payment_request.approve!

    expect(payment_request).to be_approved
    expect(payment_request.answer).to be_paid
    expect(payment_request.answer.question).to be_answered
  end
end
