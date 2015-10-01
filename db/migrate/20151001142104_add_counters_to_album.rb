class AddCountersToAlbum < ActiveRecord::Migration
  def change
    add_column :albums, :photos_count, :integer, :default => 0
    add_column :albums, :videos_count, :integer, :default => 0
    add_column :albums, :texts_count, :integer, :default => 0
  end
end
