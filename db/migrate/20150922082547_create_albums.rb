class CreateAlbums < ActiveRecord::Migration
  def change
    create_table :albums do |t|
      t.integer :user_id, index: true
      t.string :title
      t.string :description
      t.string :cover
      t.boolean :default, default: false
      t.date :start_date
      t.date :end_date
      t.string :location_name
      t.float :latitude
      t.float :longitude
      t.timestamps null: false
    end

    add_index :albums, :created_at
  end
end
