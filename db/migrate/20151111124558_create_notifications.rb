class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.references :user, index: true
      t.references :content, polymorphic: true, index: true
      t.boolean :viewed, default: false
      t.integer :event

      t.timestamps null: false
    end
    add_column :users, :unread_notifications_count, :integer, default: 0
  end
end
