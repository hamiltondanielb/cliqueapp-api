class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.references :user, foreign_key: true, null:false
      t.string :title, null:false
      t.text :description
      t.integer :difficulty_level
      t.boolean :women_only, default: false

      t.timestamps
    end
  end
end
