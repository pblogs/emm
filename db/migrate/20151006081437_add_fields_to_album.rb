class AddFieldsToAlbum < ActiveRecord::Migration
  def change
    add_column :albums, :privacy, :integer, default: 0
    add_column :albums, :color, :string
  end
end
