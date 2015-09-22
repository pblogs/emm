class CreateTributes < ActiveRecord::Migration
  def change
    create_table :tributes do |t|
      t.integer :user_id, index: true
      t.integer :author_id, index: true
      t.string :title
      t.string :description
      t.timestamps null: false
    end

    add_index :tributes, :created_at
  end
end
