class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.integer :album_id, index: true
      t.integer :content_id, index: true
      t.string :content_type, index: true
      t.integer :weight, index: true, default: 0
      t.timestamps null: false
    end

    add_index :records, :created_at
  end
end
