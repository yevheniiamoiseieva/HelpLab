FactoryBot.define do
  factory :response do
    status { "Прийнято" } # Используйте одно из допустимых значений из списка STATUSES
    association :user
    association :request
  end
end
