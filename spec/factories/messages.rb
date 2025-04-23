# spec/factories/messages.rb
FactoryBot.define do
  factory :message do
    body { "Hello" }
    association :request
    association :sender, factory: :user
    association :receiver, factory: :user
    read_at { nil }
  end
end
