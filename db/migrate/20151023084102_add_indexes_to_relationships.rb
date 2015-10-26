class AddIndexesToRelationships < ActiveRecord::Migration
  def change
    add_index :relationships, :status
    add_index :relationships, :created_at
    add_index :relationships, :updated_at
  end
end
