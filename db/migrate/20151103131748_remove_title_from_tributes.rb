class RemoveTitleFromTributes < ActiveRecord::Migration
  def up
    remove_column :tributes, :title
  end

  def down
    add_column :tributes, :title, :string
  end
end
