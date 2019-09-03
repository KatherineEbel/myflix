class Video < ApplicationRecord
  belongs_to :category, foreign_key: :category_id, class_name: 'Category'
  validates_presence_of :title
  validates_presence_of :description
end