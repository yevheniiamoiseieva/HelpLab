require 'rails_helper'

RSpec.describe Request, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:category) }
    it { should validate_presence_of(:location) }
    it { should validate_presence_of(:status) }
    it { should validate_inclusion_of(:status).in_array(Request::STATUSES) }

    context 'with invalid category' do
      it 'is invalid' do
        request = build(:request, category: 'invalid_category')
        expect(request).not_to be_valid
      end
    end
  end

  describe 'scopes' do
    it 'returns only active requests created in this test' do
      # Очистить все связанные записи перед удалением requests
      Notification.delete_all
      Response.delete_all
      Message.delete_all
      Request.delete_all

      active = create(:request, status: 'Потрібна допомога', location: 'Київ')
      in_progress = create(:request, status: 'У процесі', location: 'Львів')
      create(:request, status: 'Завершено', location: 'Харків')

      active_scope = Request.active.where(id: [active.id, in_progress.id])

      expect(active_scope).to contain_exactly(active, in_progress)
    end
  end

  describe '#close' do
    let(:user) { create(:user) }
    let(:request) { create(:request, user: user, status: 'У процесі') }
    let!(:response) { create(:response, request: request) }

    it 'changes status to completed' do
      request.close
      expect(request.status).to eq('Завершено')
    end

    it 'sends notifications' do
      Notification.destroy_all

      expect {
        request.close
      }.to change(Notification, :count).by(1)

      notification = Notification.last
      expect(notification.user).to eq(user)
      expect(notification.request).to eq(request)
      expect(notification.message).to include("Запит")
    end
  end

  describe 'edge cases' do
    it 'handles very long titles' do
      request = create(:request, title: 'A' * 255)
      expect(request).to be_valid
    end

    it 'fails with too long title' do
      request = build(:request, title: 'A' * 256)
      expect(request).not_to be_valid
    end
  end
end
