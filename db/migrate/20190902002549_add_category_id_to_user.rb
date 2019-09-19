class AddCategoryIdToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :videos, 'category_id', :integer
  end
end
