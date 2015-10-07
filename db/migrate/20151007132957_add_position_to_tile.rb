class AddPositionToTile < ActiveRecord::Migration
  def change
    add_column :tiles, :row, :integer, index: true
    add_column :tiles, :column, :integer, index: true
    add_column :tiles, :set_for_screen_size, :string
  end
end
