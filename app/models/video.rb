# frozen_string_literal: true

class Video < ApplicationRecord
  belongs_to :category, foreign_key: :category_id, class_name: 'Category'
  validates_presence_of :title
  validates_presence_of :description

  def self.search_by_title(query)
    return [] if query.empty?

    where('LOWER(title) LIKE ?', "%#{query.downcase}%")
      .order('created_at DESC')
  end
end
