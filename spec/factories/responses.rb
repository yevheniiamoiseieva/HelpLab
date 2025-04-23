# spec/factories/responses.rb
FactoryBot.define do
  factory :response do
    status { "Прийнято" } # или "Відхилено"
    association :user
    association :request
  end
end
