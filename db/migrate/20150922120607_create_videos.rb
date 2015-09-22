class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.integer :album_id, index: true
      t.string :title
      t.string :description
      t.string :preview
      t.string :video_id
      t.timestamps null: false
    end

    add_index :videos, :created_at
  end
end
