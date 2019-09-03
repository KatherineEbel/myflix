# frozen_string_literal: true

require 'rails_helper'

describe Category, type: :model do
  describe 'associations' do
    it { should have_many :videos }
  end

  describe 'recent_videos' do
    before do
      @category = Category.create(name: 'Comedy')
      @first_videos = Video.create([{
                                     title: 'Video 1',
                                     description: 'A great video',
                                     category: @category,
                                     created_at: 5.days.ago
                                   }, {
                                     title: 'Video 2',
                                     description: 'Non stop action',
                                     category: @category,
                                     created_at: 3.days.ago
                                   }, {
                                     title: 'Video 3',
                                     description: 'Third in series',
                                     category: @category,
                                     created_at: 6.days.ago
                                   }])
    end
    it 'should return an empty array if category has no videos' do
      category = Category.create(name: 'Comedy')
      expect(category.recent_videos.size).to be 0
    end

    it 'should return all videos if less than 6' do
      expect(@category.recent_videos.size).to be 3
    end

    it 'should only return first 6 videos when more than 6' do
      @first_videos << Video.create([{
                                      title: 'Video 4',
                                      description: 'Romantic Comedy',
                                      category: @category
                                    }, {
                                      title: 'Video 5',
                                      description: 'Description here',
                                      category: @category
                                    }, {
                                      title: 'Video 6',
                                      description: 'Another fantastic video',
                                      category: @category
                                    }, {
                                      title: 'Video 7',
                                      description: 'Another fantastic video',
                                      category: @category
                                    }])
      expect(@category.recent_videos.size).to eq 6
    end

    it 'should return most recent videos first by created_at' do
      expect(@category.recent_videos)
        .to eq [
          @first_videos[1],
          @first_videos.first,
          @first_videos.last
        ]
    end
  end
end
