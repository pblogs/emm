class AddTypeToTiles < ActiveRecord::Migration
  def change
    add_column :tiles, :widget_type, :integer, default: 0
  end
end
