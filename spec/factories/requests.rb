FactoryBot.define do
  factory :request do
    association :user
    title { "Потрібна допомога з речами" }
    description { "Опис запиту на допомогу для тестів." }
    category { "Одяг" }
    location { nil } # Change this to nil to trigger the callback
    status { "Потрібна допомога" }

    trait :completed do
      status { "Завершено" }
    end

    trait :in_process do
      status { "У процесі" }
    end
  end
end