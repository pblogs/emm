class AddFieldsToVideo < ActiveRecord::Migration
  def change
    add_column :videos, :source, :integer
  end
end
