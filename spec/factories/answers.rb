FactoryBot.define do
  factory :answer do
    association :question
    association :lawyer, factory: :user
    response_text { Faker::Lorem.paragraph(sentence_count: 4) }
    proposed_fee_pence { Faker::Number.between(from: 1000, to: 50_000) }
    paid { false }
  end
end
