FactoryBot.define do
  factory :chat_message, class: 'Message' do
    body { "Пример сообщения" }
    association :request
    association :sender, factory: :user
    association :receiver, factory: :user
  end
end
