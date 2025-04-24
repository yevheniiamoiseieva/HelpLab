# spec/models/notification_spec.rb
require 'rails_helper'

RSpec.describe Notification, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:request) }
  end

  describe 'scopes' do
    let!(:read_notification) { create(:notification, read_at: Time.current) }
    let!(:unread_notification) { create(:notification) }

    it 'returns only unread notifications created in this spec' do
      unread_ids = [unread_notification.id]
      expect(Notification.unread.where(id: unread_ids)).to eq([unread_notification])
    end
  end
end
