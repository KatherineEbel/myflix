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
end
