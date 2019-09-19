# frozen_string_literal: true

require 'rails_helper'

describe Category, type: :model do
  describe 'associations' do
    it { should have_many :videos }
  end

  describe 'recent_videos' do
    # 5 3 6
    let(:category) { Fabricate(:category, name: 'Comedy') }

    before do
      Fabricate.times(3, :video, category: category)
    end

    it 'should return an empty array if category has no videos' do
      category = Category.create(name: 'Drama')
      expect(category.recent_videos.size).to be 0
    end

    it 'should return all videos if less than 6' do
      expect(category.recent_videos.size).to be 3
    end

    it 'should only return first 6 videos when more than 6' do
      Fabricate.times(6, :video, category: category)
      expect(category.recent_videos.size).to eq 6
    end

    it 'should return most recent videos first by created_at' do
      expect(category.recent_videos.first.created_at)
        .to be > category.recent_videos.last.created_at
    end
  end
end
