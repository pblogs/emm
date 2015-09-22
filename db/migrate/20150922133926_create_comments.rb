class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :author_id, index: true
      t.integer :commentable_id, index: true
      t.string :commentable_type, index: true
      t.string :text
      t.timestamps null: false
    end

    add_index :comments, :created_at
  end
end
