require "rails_helper"

RSpec.describe Answer, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:lawyer) { FactoryBot.create(:lawyer) }

  subject(:answer) do
    FactoryBot.build(
      :answer,
      question: FactoryBot.create(:question, user: user),
      lawyer: lawyer,
      response_text: "Here is the advice.",
      proposed_fee_pence: 2500
    )
  end

  it { is_expected.to belong_to(:question) }
  it { is_expected.to belong_to(:lawyer).class_name("User") }
  it { is_expected.to have_one(:payment_request).dependent(:destroy) }

  it { is_expected.to validate_presence_of(:response_text) }
  it { is_expected.to validate_numericality_of(:proposed_fee_pence).is_greater_than(0) }

  it "creates a pending payment request after create" do
    answer = FactoryBot.create(
      :answer,
      question: FactoryBot.create(:question, user: user),
      lawyer: lawyer
    )

    expect(answer.payment_request).to be_present
    expect(answer.payment_request).to be_pending
  end

  it "converts the fee into pounds" do
    answer.proposed_fee_pence = 2500

    expect(answer.fee_in_pounds).to eq(25.0)
  end
end
