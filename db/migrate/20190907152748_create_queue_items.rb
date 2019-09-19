class CreateQueueItems < ActiveRecord::Migration[6.0]
  def change
    create_table :queue_items do |t|
      t.integer :priority
      t.integer :user_id
      t.integer :video_id
      t.timestamps
    end
  end
end
