FactoryBot.define do
  factory :request do
    association :user
    title { "Потрібна допомога з речами" }
    description { "Опис запиту на допомогу для тестів." }
    category { Request::CATEGORIES.sample }
    location { "Київ, Україна" }
    status { Request::STATUSES.first }

    trait :completed do
      status { "Завершено" }
    end

    trait :in_process do
      status { "У процесі" }
    end
  end
end
