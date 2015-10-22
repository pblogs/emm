class CreateRelationship < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.references :user, index: true
      t.references :friend, index: true
      t.integer :status, default: 0

      t.timestamps null: false
    end
  end
end
