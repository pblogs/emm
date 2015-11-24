class AddCountersToUser < ActiveRecord::Migration
  def change
    add_column :users, :albums_count, :integer, default: 0
    add_column :users, :relationships_count, :integer, default: 0
    add_column :users, :photos_count, :integer, default: 0
    add_column :users, :videos_count, :integer, default: 0
    add_column :users, :texts_count, :integer, default: 0
  end
end
