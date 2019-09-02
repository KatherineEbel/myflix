class Video < ApplicationRecord
  belongs_to :category, foreign_key: :category_id, class_name: 'Category'
end