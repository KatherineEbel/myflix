class QueueItem < ApplicationRecord
  belongs_to :video, foreign_key: 'video_id'
  belongs_to :user, foreign_key: 'user_id'

  delegate :category, :title, to: :video

  def category_name
    category.name
  end

  def video_title
    title
  end
end