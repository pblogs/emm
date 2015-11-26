class AddStorageToPages < ActiveRecord::Migration
  def change
    add_column :pages, :storage, :boolean, default: false
  end
end
