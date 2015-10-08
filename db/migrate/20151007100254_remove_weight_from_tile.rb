class RemoveWeightFromTile < ActiveRecord::Migration

  def up
    remove_column :tiles, :weight
  end

  def down
    add_column :tiles, :weight, :integer, index: true, default: 0
  end
end
