# frozen_string_literal: true

class Video < ApplicationRecord
  belongs_to :category, foreign_key: :category_id, class_name: 'Category'
  has_many :reviews, -> { order('created_at DESC')}
  validates_presence_of :title
  validates_presence_of :description
  mount_uploader :small_cover, SmallCoverUploader
  mount_uploader :large_cover, LargeCoverUploader

  def rating_average
    reviews.average(:rating).to_f.round 1
  end

  def self.search_by_title(query)
    return [] if query.empty?

    where('LOWER(title) LIKE ?', "%#{query.downcase}%")
      .order('created_at DESC')
  end
end
