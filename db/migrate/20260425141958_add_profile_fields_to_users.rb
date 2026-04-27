class AddProfileFieldsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :name, :string
    add_column :users, :role, :string
    add_column :users, :status, :string

    add_index :users, :role
    add_index :users, :status
  end
end
