class CreateFollows < ActiveRecord::Migration[5.1]
  def change
    create_table :follows do |t|
      t.references :follower, table: :users, foreign_key: {to_table: :users}
      t.references :followed, table: :users, foreign_key: {to_table: :users}

      t.timestamps
    end
  end
end
