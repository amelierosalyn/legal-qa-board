FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    sequence(:email) { |n| "#{Faker::Internet.username}#{n}@example.com" }
    role { :client }
  end

  factory :lawyer, class: "User" do
    name { Faker::Name.name }
    sequence(:email) { |n| "#{Faker::Internet.username}#{n}@example.com" }
    role { :lawyer }
  end
end
