class AddPositionToTile < ActiveRecord::Migration
  def change
    add_column :tiles, :row, :integer, index: true
    add_column :tiles, :col, :integer, index: true
    add_column :tiles, :screen_size, :integer, default: 0
  end
end
