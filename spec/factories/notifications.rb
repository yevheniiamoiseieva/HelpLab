FactoryBot.define do
  factory :notification do
    association :user
    association :request
    read_at { nil }
  end
end
