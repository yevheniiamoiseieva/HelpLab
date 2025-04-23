require 'rails_helper'

RSpec.describe Request, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
    it { should validate_inclusion_of(:status).in_array(Request::STATUSES) }

    context 'with invalid category' do
      it 'is invalid' do
        request = build(:request, category: 'invalid_category')
        expect(request).not_to be_valid
      end
    end
  end

  describe 'scopes' do
    let!(:active_request) { create(:request, status: 'active') }
    let!(:completed_request) { create(:request, :completed) }

    it 'returns only active requests' do
      expect(Request.active).to eq([active_request])
    end
  end

  describe '#close' do
    let(:request) { create(:request) }

    it 'changes status to completed' do
      request.close
      expect(request.status).to eq('completed')
    end

    it 'sends notifications' do
      expect {
        request.close
      }.to change(Notification, :count).by(1)
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