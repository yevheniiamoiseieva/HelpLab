# spec/factories/reviews.rb
FactoryBot.define do
  factory :review do
    rating { rand(1..5) }
    comment { "Все супер!" }
    association :reviewed_user, factory: :user
    association :author, factory: :user
  end
end
