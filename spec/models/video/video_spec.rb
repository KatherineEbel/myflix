# frozen_string_literal: true

require 'rails_helper'

describe Video, type: :model do
  describe 'associations' do
    it { should belong_to(:category).class_name('Category') }
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
end
