require 'rails_helper'

describe QueueItem, type: :model do
  describe 'associations' do
    it { should belong_to :user }
    it { should belong_to :video }
  end

  describe '#video_title' do
    it 'should return the videos title' do
      video = Fabricate(:video, title: 'South Park')
      queue_item = Fabricate(:queue_item, user: Fabricate(:user), video: video)
      expect(queue_item.video_title).to eq 'South Park'
    end
  end

  describe '#category' do
    it 'should return the items video category' do
      category = Fabricate(:category, name: 'Comedy')
      video = Fabricate(:video, category: category)
      queue_item = Fabricate(:queue_item, user: Fabricate(:user), video: video)
      expect(queue_item.category).to be category
    end
  end

  describe '#category_name' do
    it 'should return video category name' do
      video = Fabricate(:video, category: Fabricate(:category, name: 'Comedy'))
      queue_item = Fabricate(:queue_item, user: Fabricate(:user), video: video)
      expect(queue_item.category_name).to eq 'Comedy'
    end
  end
end