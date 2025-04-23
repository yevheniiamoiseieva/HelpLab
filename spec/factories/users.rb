FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'password123' }
    confirmed_at { Time.current }
    role { 'regular' }

    trait :regular do
      role { 'regular' }
    end

    trait :volunteer do
      role { 'volunteer' }
    end
  end
end
