class QueueItem < ApplicationRecord
  belongs_to :video, foreign_key: 'video_id'
  belongs_to :user, foreign_key: 'user_id'
  validates_numericality_of :priority, only_integer: true, on: :update
  validates_uniqueness_of :video_id, scope: :user_id
  after_create :calculate_priority
  delegate :category, :title, to: :video

  def category_name
    category.name
  end

  def rating
    review&.rating
  end

  def rating=(value)
    if review
      review.update(rating: value)
    else
      user.reviews << Review.create(rating: value, video: video)
    end
  end

  def video_title
    title
  end

  def self.update_queue(items_attributes, user_id)
    queue_items = sort_by_priority(changed_items(items_attributes, user_id))
    normalize_priorities(queue_items)
  end

  class << self
    def changed_items(items_attributes, user_id)
      items_attributes
        .values
        .map do |attributes|
        item = QueueItem.find(attributes[:id])
        raise ActiveRecord::RecordNotFound if item.nil?

        item.priority = attributes[:priority]
        item.rating = attributes[:rating] if attributes[:rating]
        raise ActiveRecord::RecordInvalid if invalid_update? item, user_id

        item
      end
    end

    def invalid_update?(item, user_id)
      item.user.id != user_id || item.invalid?
    end

    def normalize_priorities(items)
      transaction do
        items.each_with_index do |item, idx|
          item.update!(priority: idx + 1)
        end
      end
    end

    def sort_by_priority(items)
      items.sort_by(&:priority)
    end
  end

  private

  def calculate_priority
    update(priority: QueueItem.where(user: user).count)
  end

  def review
    @review ||= user.reviews.where(video: video).first
  end
end
