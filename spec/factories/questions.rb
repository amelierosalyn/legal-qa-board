FactoryBot.define do
  factory :question do
    association :user
    title { Faker::Lorem.sentence(word_count: 6).chomp(".") }
    body { Faker::Lorem.paragraph(sentence_count: 3) }
    category { Question::CATEGORIES.sample }
    status { :open }
  end
end
