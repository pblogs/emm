class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.integer :album_id, index: true
      t.string :title
      t.string :description
      t.string :image
      t.timestamps null: false
    end

    add_index :photos, :created_at
  end
end
