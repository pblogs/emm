class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.references :user, index: true
      t.references :target, polymorphic: true, index: true

      t.timestamps null: false
    end

    add_column :texts, :likes_count, :integer, default: 0, null: false
    add_column :photos, :likes_count, :integer, default: 0, null: false
    add_column :videos, :likes_count, :integer, default: 0, null: false
    add_column :tributes, :likes_count, :integer, default: 0, null: false
    add_column :comments, :likes_count, :integer, default: 0, null: false
  end
end
