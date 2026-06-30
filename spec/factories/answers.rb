FactoryBot.define do
  factory :answer do
    association :question
    association :lawyer, factory: :user
    response_text { "Answer text" }
    proposed_fee_pence { 1_500 }
    paid { false }
  end
end
