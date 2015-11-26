class AddSettingsToTiles < ActiveRecord::Migration
  def change
    add_column :tiles, :show_comments_count, :boolean, default: false
    add_column :tiles, :show_tags_count, :boolean, default: false
  end
end
