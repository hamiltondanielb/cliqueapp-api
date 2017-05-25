class RemoveDateAndTimeFromEvents < ActiveRecord::Migration[5.1]
  def change
    remove_column :events, :date, :date
    remove_column :events, :time, :time
  end
end
