class AddOriginalIdToMedia < ActiveRecord::Migration
  def change
    add_column :texts, :original_id, :integer, default: nil, index: true
    add_column :photos, :original_id, :integer, default: nil, index: true
    add_column :videos, :original_id, :integer, default: nil, index: true
  end
end
