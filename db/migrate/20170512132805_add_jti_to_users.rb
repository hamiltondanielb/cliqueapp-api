class AddJtiToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :jti, :string
    change_column :users, :jti, :string, null:false
    add_index :users, :jti, unique: true
  end
end
