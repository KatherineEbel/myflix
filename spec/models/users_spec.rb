require 'rails_helper'

describe User, type: :model do
  describe 'associations' do
    it { should have_many(:reviews) }
    it { should have_many(:queue_items) }
  end
  describe 'validations' do
    it { should have_secure_password }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:full_name) }
    it { should validate_presence_of(:password_digest) }
    it { should validate_uniqueness_of(:email) }
  end

  describe '#review_for' do
    let(:user) { Fabricate(:user) }
    it 'should return the review for given video_id if exists' do
      review = Fabricate(:review, reviewer: user)
      result = user.review_for(review.video)
      expect(result).to eq Review.first
    end

    it 'should return nil if there is no review' do
      review = Fabricate(:review, reviewer: Fabricate(:user))
      result = user.review_for(review.video)
      expect(result).to be_nil
    end
  end
end
