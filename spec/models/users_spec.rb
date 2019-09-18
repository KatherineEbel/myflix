require 'rails_helper'

describe User, type: :model do
  it { should respond_to :followed_users }
  it { should respond_to :following_users }
  describe 'associations' do
    it { should have_many(:reviews).order('created_at DESC') }
    it { should have_many(:queue_items) }
    it { should have_many(:followed_users) }
    it { should have_many(:following_users) }
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

  describe '#queued?' do
    it 'should return true if the video is already in queue' do
      user = Fabricate(:user)
      queue_item = Fabricate(:queue_item, user: user)
      expect(user.queued?(queue_item.video)).to be true
    end

    it 'should return false if the video is not in users queue' do
      user = Fabricate(:user)
      video = Fabricate(:video)
      expect(user.queued?(video)).to be false
    end
  end

  describe '#gravatar_url' do
    it 'should return users email combined with hash' do
      user = Fabricate(:user)
      expect(user.gravatar_url).to match(%r(^https://www.gravatar.com/avatar))
    end

    it 'should use 40 as default size if not passed in' do
      user = Fabricate(:user)
      expect(user.gravatar_url).to match(%r(^https://www.gravatar.com/avatar/\w+\?size=40$))
    end
    it 'should include the size if passed in' do
      user = Fabricate(:user)
      expect(user.gravatar_url(size: 200)).to match(%r(^https://www.gravatar.com/avatar/\w+\?size=200$))
    end
  end

  describe '#follow!' do
    it { should respond_to :follow! }
    context 'user is not following other user' do
      it 'should add other_user to followed_users' do
        user = Fabricate(:user)
        other_user = Fabricate(:user)
        user.follow!(other_user)
        expect(user.followees).to include other_user
      end
    end

    context 'user is already following other user' do
      it 'should throw an error' do
        user = Fabricate(:user)
        other_user = Fabricate(:user)
        user.follow!(other_user)
        expect { user.follow!(other_user) }.to(
          raise_error(ActiveRecord::RecordInvalid)
        )
      end
    end
  end

  describe '#following?' do
    it { should respond_to :following? }
    let(:user) { Fabricate(:user) }
    let(:other_user) { Fabricate(:user) }
    it 'should return true if user is following other_user' do
      user.follow!(other_user)
      expect(user.following?(other_user)).to be true
    end

    it 'should return false if user is not following other_user' do
      expect(user.following?(other_user)).to be false
    end
  end
end
