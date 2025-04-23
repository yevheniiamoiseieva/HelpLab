# spec/factories/notifications.rb
FactoryBot.define do
  factory :notification do
    association :user
    association :notifiable, factory: :message
    read_at { nil }
  end
end
