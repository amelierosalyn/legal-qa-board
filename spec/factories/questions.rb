FactoryBot.define do
  factory :question do
    association :user
    sequence(:title) { |n| "Question #{n}" }
    body { "Question details" }
    category { "Housing" }
    status { :open }
  end
end
