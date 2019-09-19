require 'rails_helper'

describe QueueItem, type: :model do
  describe 'associations' do
    it { should belong_to :user }
    it { should belong_to :video }
    it { should validate_numericality_of(:priority).on(:update) }
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

  describe '#rating' do
    context 'user has review for video' do
      let(:user) { Fabricate(:user) }
      it 'should return the rating' do
        review = Fabricate(:review, reviewer: user, rating: 6)
        queue_item = Fabricate(:queue_item, user: user, video: review.video)
        expect(queue_item.rating).to eq review.rating
      end
    end

    context 'user has not reviewed video' do
      let(:user) { Fabricate(:user) }
      it 'should return nil' do
        queue_item = Fabricate(:queue_item, user: user)
        expect(queue_item.rating).to be_nil
      end
    end
  end

  describe '#review=' do
    let(:user) { Fabricate(:user) }
    it 'should create a new review if user does not have one for this video' do
      queue_item = Fabricate(:queue_item, user: user)
      queue_item.rating = '5'
      expect(user.reviews.count).to eq 1
      expect(queue_item.rating).to eq user.reviews.first.rating
    end

    it 'should update existing review with new rating' do
      queue_item = Fabricate(:queue_item, user: user)
      user.reviews << Fabricate(:review, video: queue_item.video)

      queue_item.rating = 3
      expect(user.reviews.count).to eq 1
      expect(user.reviews.first.rating).to eq 3
    end
  end

  describe 'after_create' do
    it 'should set the priority to one if it is the first queue item' do
      queue_item = Fabricate(:queue_item, priority: nil)
      expect(queue_item.priority).to eq 1
    end

    it 'should set newest item to last priority value' do
      user = Fabricate(:user)
      Fabricate(:queue_item, priority: nil, user: user)
      Fabricate(:queue_item, priority: nil, user: user)
      queue_item3 = Fabricate(:queue_item, priority: nil, user: user)
      expect(queue_item3.priority).to eq 3
    end

    it 'should not add the same video twice' do
      user = Fabricate(:user)
      video = Fabricate(:video)
      Fabricate(:queue_item, priority: nil, user: user, video: video)
      expect { Fabricate(:queue_item, priority: nil, user: user, video: video) }
        .to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe '::update_queue' do
    it 'should save updated priority values for given values' do
      user = Fabricate(:user)
      video = Fabricate(:video)
      video2 = Fabricate(:video)
      item1 = Fabricate(:queue_item, user: user, video: video)
      item2 = Fabricate(:queue_item, user: user, video: video2)
      attributes = { '0': { priority: 6, id: item1.to_param },
                     '1': { priority: 2, id: item2.to_param } }
      QueueItem.update_queue(attributes, user.id)
      expect(QueueItem.find(item1.to_param).priority).to eq 2
      expect(QueueItem.find(item2.to_param).priority).to eq 1
    end

    context 'different user' do
      let(:current_user) { Fabricate(:user) }
      it 'should not update priorities' do
        video = Fabricate(:video)
        video2 = Fabricate(:video)
        bob = Fabricate(:user)
        queue_item1 = Fabricate(:queue_item, user: bob, video: video)
        queue_item2 = Fabricate(:queue_item, user: bob, video: video2)
        attributes = { '0': { priority: 3, id: queue_item1.to_param },
                       '1': { priority: 2, id: queue_item2.to_param } }
        expect { QueueItem.update_queue(attributes, current_user.id) }
          .to raise_error ActiveRecord::RecordInvalid
      end
    end

    context 'invalid data' do
      let(:current_user) { Fabricate(:user) }
      it 'should not update priorities' do
        video = Fabricate(:video)
        video2 = Fabricate(:video)
        queue_item1 = Fabricate(:queue_item, user: current_user, video: video)
        queue_item2 = Fabricate(:queue_item, user: current_user, video: video2)
        attributes = { '0': { priority: 3.5, id: queue_item1.to_param },
                       '1': { priority: 2, id: queue_item2.to_param } }
        expect { QueueItem.update_queue(attributes, current_user.id) }
          .to raise_error ActiveRecord::RecordInvalid
      end
    end

    context 'udpating reviews' do
      before do
        # this is here because extra queue items somehow in database
        QueueItem.destroy_all
      end
      context 'user has not reviewed video' do
        let(:user) { Fabricate(:user) }
        it 'should add new reviews using given item attributes' do
          Fabricate.times(2, :queue_item, user: user)
          item_attributes = { '0': { priority: 1, rating: 5, id: QueueItem.first.id },
                              '1': { priority: 2, rating: 3, id: QueueItem.second.id } }
          QueueItem.update_queue(item_attributes, user.id)
          expect(user.reviews.map(&:rating)).to match_array [5, 3]
        end
      end

      context 'user has review for one video but not another' do
        let(:user) { Fabricate(:user) }
        it 'should update or create review as needed' do
          Fabricate.times(3, :queue_item, user: user)
          item_attributes = { '0': { priority: 1, rating: '', id: user.queue_items.first.id },
                              '1': { priority: 2, rating: '', id: user.queue_items.second.id },
                              '2': { priority: 3, rating: 4, id: user.queue_items.third.id } }
          QueueItem.update_queue(item_attributes, user.id)
          expect(user.reviews.count).to eq 1
          expect(user.reviews.first.rating).to eq 4
        end
      end
    end
  end



  describe '::invalid_update?' do
    it 'should return false if user_id the same as item.user.id' do
      user = Fabricate(:user)
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      expect(QueueItem.invalid_update?(queue_item, user.id)).to be false
    end

    it 'should return false if item is valid' do
      user = Fabricate(:user)
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      queue_item.priority = 6
      expect(QueueItem.invalid_update?(queue_item, user.id)).to be false
    end
    it 'should return true if user_id different from item.user.id' do
      bob = Fabricate(:user)
      user = Fabricate(:user)
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      expect(QueueItem.invalid_update?(queue_item, bob.id)).to be true
    end

    it 'should return true if item is invalid' do
      user = Fabricate(:user)
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      queue_item.priority = 3.5
      expect(QueueItem.invalid_update?(queue_item, user.id)).to be true
    end
  end

  describe '::sort_by_priority' do
    it 'should sort items with priorities 6,1,3 to 1,3,6' do
      user = Fabricate(:user)
      Fabricate.times(3, :video)
      Fabricate(:queue_item, user: user, video: Video.first, priority: 6)
      Fabricate(:queue_item, user: user, video: Video.second, priority: 1)
      Fabricate(:queue_item, user: user, video: Video.third, priority: 3)
      sorted_videos = QueueItem
                      .sort_by_priority(
                        [QueueItem.first,
                         QueueItem.second,
                         QueueItem.third]
                      )
      expect(
        QueueItem.sort_by_priority(sorted_videos)
      ).to match_array [QueueItem.second,
                        QueueItem.third,
                        QueueItem.first]
    end
  end

  describe '::changed_items' do
    context 'valid attributes' do
      it 'should set the new priorities on the matching items' do
        user = Fabricate(:user)
        Fabricate.times(3, :queue_item, user: user)
        attributes = { '0': { priority: 3, id: user.queue_items.first.id },
                       '1': { priority: 1, id: user.queue_items.second.id },
                       '2': { priority: 2, id: user.queue_items.third.id } }
        items = QueueItem.changed_items(attributes, user.id)
        expect(items.map(&:priority)).to match_array [3, 1, 2]
      end
    end

    context 'invalid attributes' do
      let(:user) { Fabricate(:user) }
      it 'should raise NotFound error when attribute id not found' do
        Fabricate.times(3, :queue_item, user: user)
        attributes = { '0': { priority: 3, id: user.queue_items.first.id },
                       '1': { priority: 1, id: user.queue_items.second.id },
                       '2': { priority: 2, id: 10 } }
        expect { QueueItem.changed_items(attributes, user.id) }
          .to raise_error(ActiveRecord::RecordNotFound)
      end
      it 'should raise RecordInvalid if priority value is invalid' do
        Fabricate(:queue_item, user: user)
        attributes = { '0': { priority: 3.5, id: user.queue_items.first.id } }
        expect { QueueItem.changed_items(attributes, user.id) }
          .to raise_error(ActiveRecord::RecordInvalid)
      end

      it "should raise RecordInvalid if user_id doesn't match item user" do
        Fabricate(:queue_item, user: user)
        attributes = { '0': { priority: 3, id: user.queue_items.first.id } }
        expect { QueueItem.changed_items(attributes, user.id + 1) }
          .to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  describe '::normalize_priorities' do
    it 'should update a list of 3 items with priorities ordered from 1 to 3' do
      user = Fabricate(:user)
      Fabricate(:queue_item, user: user, priority: 6)
      Fabricate(:queue_item, user: user, priority: 3)
      Fabricate(:queue_item, user: user, priority: 2)
      QueueItem.normalize_priorities(user.queue_items)
      expect(user.queue_items.map(&:priority)).to match_array [1, 2, 3]
    end
  end
end
