# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_one(:profile) }
    it { should have_many(:requests) }
    it { should have_many(:responses) }
    it { should have_many(:notifications) }
    it { should have_many(:reviews).with_foreign_key('reviewed_user_id') }
    it { should have_many(:authored_reviews).class_name('Review').with_foreign_key('author_id') }
  end
  describe 'validations' do
    it { should validate_presence_of(:role) }
    it { should validate_inclusion_of(:role).in_array(User::ROLES.values) }
  end

  describe 'scopes' do
    let!(:volunteer) { create(:user, role: 'volunteer') }
    let!(:regular) { create(:user, role: 'regular') }

    it 'returns only volunteers' do
      expect(User.volunteers).to include(volunteer)
      expect(User.volunteers).not_to include(regular)
    end

    it 'returns only regular users' do
      expect(User.regular_users).to include(regular)
      expect(User.regular_users).not_to include(volunteer)
    end
  end

  describe '#average_rating' do
    let(:user) { create(:user) }

    it 'returns 0 if there are no reviews' do
      expect(user.average_rating).to eq(0)
    end

    it 'returns average rating if reviews exist' do
      create(:review, reviewed_user: user, rating: 4)
      create(:review, reviewed_user: user, rating: 5)
      expect(user.average_rating).to eq(4.5)
    end
  end

  describe '#volunteer?' do
    it 'returns true if role is volunteer' do
      user = build(:user, role: 'volunteer')
      expect(user.volunteer?).to be(true)
    end

    it 'returns false if role is regular' do
      user = build(:user, role: 'regular')
      expect(user.volunteer?).to be(false)
    end
  end

  describe '#regular?' do
    it 'returns true if role is regular' do
      user = build(:user, role: 'regular')
      expect(user.regular?).to be(true)
    end

    it 'returns false if role is volunteer' do
      user = build(:user, role: 'volunteer')
      expect(user.regular?).to be(false)
    end
  end

  describe 'callbacks' do
    it 'creates profile after user is created' do
      user = create(:user)
      expect(user.profile).to be_present
      expect(user.profile.first_name).to eq(user.email.split('@').first)
    end
  end
end
