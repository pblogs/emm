class RenameRelationshipsColumns < ActiveRecord::Migration
  def change
    rename_column :relationships, :user_id, :sender_id
    rename_column :relationships, :friend_id, :recipient_id
  end
end
