class MoveTilesFromUserToPage < ActiveRecord::Migration
  def up
    add_column :tiles, :page_id, :integer, index: true
    remove_column :tiles, :user_id
  end

  def down
    remove_column :tiles, :page_id
    add_column :tiles, :user_id, :integer, index: true
  end
end
