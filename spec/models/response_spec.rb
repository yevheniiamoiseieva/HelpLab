require 'rails_helper'

RSpec.describe Response, type: :model do
  describe 'associations' do
    it { should belong_to(:request) }
    it { should belong_to(:user) }
    it { should have_many(:messages) }
  end

  describe 'validations' do
    it { should validate_presence_of(:status) }
    it { should validate_inclusion_of(:status).in_array(Response::STATUSES) }
  end

  describe 'scopes' do
    let!(:pending) { create(:response, status: 'pending') }
    let!(:accepted) { create(:response, status: 'accepted') }

    it '.pending returns only pending responses' do
      expect(Response.pending).to eq([pending])
    end
  end
end