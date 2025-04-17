FactoryBot.define do
  factory :profile do
    first_name { "John" }
    last_name { "Doe" }
    bio { "A short bio about John." }
    country { "USA" }
    city { "New York" }
    # Если у тебя есть ассоциация с User, добавь это:
    association :user
  end
end
