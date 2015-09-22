class CreateTexts < ActiveRecord::Migration
  def change
    create_table :texts do |t|
      t.integer :album_id, index: true
      t.string :title
      t.string :description
      t.timestamps null: false
    end

    add_index :texts, :created_at
  end
end
