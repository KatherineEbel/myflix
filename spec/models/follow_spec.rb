require 'rails_helper'

describe Follow do
  describe 'associations' do
    it { should belong_to :follower }
    it { should belong_to :followee }
  end

  describe 'validations' do
    it { should validate_uniqueness_of(:follower_id).scoped_to(:followee_id) }
  end

  it 'should not be able to follow a user more than once' do
    user = Fabricate(:user)
    user2 = Fabricate(:user)
    user.followees << user2
    expect { user.followees << user2 }.to raise_error(ActiveRecord::RecordInvalid)
  end
end
