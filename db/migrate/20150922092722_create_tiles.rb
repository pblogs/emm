class CreateTiles < ActiveRecord::Migration
  def change
    create_table :tiles do |t|
      t.integer :user_id, index: true
      t.integer :content_id, index: true
      t.string :content_type, index: true
      t.integer :weight, index: true, default: 0
      t.integer :size, default: 0
      t.timestamps null: false
    end

    add_index :tiles, :created_at
  end
end
