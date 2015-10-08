class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.integer :user_id, index: true
      t.integer :weight, index: true, default: 0
      t.boolean :default, default: false
      t.timestamps null: false
    end

    add_index :pages, :created_at
  end
end
