class AddPageAliasToUsers < ActiveRecord::Migration
  def change
    add_column :users, :page_alias, :string, index: {unique: true}
  end
end
