# spec/models/notification_spec.rb
require 'rails_helper'

RSpec.describe Notification, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:notifiable) }
  end

  describe 'scopes' do
    let!(:read_notification) { create(:notification, read_at: Time.current) }
    let!(:unread_notification) { create(:notification) }

    it 'returns only unread notifications' do
      expect(Notification.unread).to eq([unread_notification])
    end
  end
end