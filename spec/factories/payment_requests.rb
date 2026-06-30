FactoryBot.define do
  factory :payment_request do
    association :answer
    status { :pending }
  end
end
