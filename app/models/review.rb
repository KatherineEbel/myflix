class Review < ApplicationRecord
  belongs_to :reviewer, foreign_key: 'user_id', class_name: 'User'
  belongs_to :video, foreign_key: 'video_id', class_name: 'Video'

  validates_presence_of :rating
end