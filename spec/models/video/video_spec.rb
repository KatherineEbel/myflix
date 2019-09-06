# frozen_string_literal: true

require 'rails_helper'

describe Video, type: :model do
  describe 'associations' do
    it { should belong_to(:category).class_name('Category') }
    it { should have_many(:reviews) }

    it 'should order reviews by the most recent first' do
      video = Fabricate(:video)
      Fabricate(:review, video: video, rating: 4, created_at: 3.days.ago)
      review2 = Fabricate(:review, video: video, rating: 4)
      expect(video.reviews.first).to eq review2
    end
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
  end

  describe 'search_by_title' do
    before do
      category = Category.create(name: 'Comedies')
      @videos = Video.create([{
                               title: 'Video 1',
                               description: 'a really boring movie',
                               category: category,
                               created_at: 2.days.ago
                             }, {
                               title: 'Video 2',
                               description: 'what pets do while their owners are away',
                               category: category
                             }])
    end

    it 'should return an empty array if no videos match' do
      videos = Video.search_by_title('not found')
      expect(videos.size).to eq 0
    end

    it 'should return an array of one video for exact match' do
      videos = Video.search_by_title('Video 1')
      expect(videos).to include @videos.first
      expect(videos.size).to be 1
    end

    it 'should return an array with matches sorted_by created at' do
      videos = Video.search_by_title('Video')
      expect(videos).to match_array [@videos.last, @videos.first]
    end

    it 'should return an empty array if query empty' do
      videos = Video.search_by_title ''
      expect(videos).to match_array []
    end
  end
  describe '#review_average' do
    let(:video) { Fabricate(:video) }
    it 'should calculate the average rating for all reviews' do
      Fabricate.times(3, :review, video: video, rating: 4)
      expect(video.rating_average).to eq 4
    end

    it 'should calculate another rating' do
      Fabricate.times(2, :review, video: video, rating: 3)
      Fabricate(:review, video: video, rating: 2)
      expect(video.rating_average).to eq 2.7
    end
  end
end
