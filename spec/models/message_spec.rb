# spec/models/message_spec.rb
require 'rails_helper'

RSpec.describe Message, type: :model do
  describe 'associations' do
    it { should belong_to(:request) }
    it { should belong_to(:sender).class_name('User') }
    it { should belong_to(:receiver).class_name('User') }
  end

  describe 'validations' do
    it { should validate_presence_of(:body) }

    context 'length validation' do
      it { should allow_value('AB').for(:body) }        # 2 символа - валидно
      it { should_not allow_value('A').for(:body) }     # 1 символ - невалидно
      it { should allow_value('A' * 1000).for(:body) }  # 1000 символов - валидно
      it { should_not allow_value('A' * 1001).for(:body) } # 1001 символ - невалидно
    end
  end

  describe 'scopes' do
    let!(:unread) { create(:message, read_at: nil) }
    let!(:read) { create(:message, read_at: Time.current) }

    it '.unread returns only unread messages' do
      expect(Message.unread).to eq([unread])
    end
  end
end