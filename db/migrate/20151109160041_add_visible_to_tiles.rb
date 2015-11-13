class AddVisibleToTiles < ActiveRecord::Migration
  def change
    add_column :tiles, :visible, :boolean, default: true
  end
end
