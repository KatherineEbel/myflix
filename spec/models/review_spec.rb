require 'rails_helper'

describe Review, type: :model do
  describe 'associations' do
    it { should belong_to :video }
    it { should belong_to :reviewer }
  end

  describe 'validations' do
    it { should validate_presence_of :rating }
  end
end
