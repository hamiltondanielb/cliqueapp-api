class AddFieldsToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :difficulty_level, :integer
    add_column :events, :women_only, :boolean, default:false
    add_column :events, :price, :decimal, precision:8, scale:2
  end
end
