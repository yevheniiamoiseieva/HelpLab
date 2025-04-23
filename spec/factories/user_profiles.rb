FactoryBot.define do
  factory :profile do
    first_name { "John" }
    last_name { "Doe" }
    bio { "A short bio about John." }
    country { "USA" }
    city { "New York" }
    association :user
  end
end
