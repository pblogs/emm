class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.integer :author_id, index: true
      t.integer :user_id, index: true
      t.references :target, polymorphic: true, index: true
      t.timestamps null: false
    end
  end
end
