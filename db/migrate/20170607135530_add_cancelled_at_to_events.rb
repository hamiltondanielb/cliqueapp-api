class AddCancelledAtToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :cancelled_at, :datetime
  end
end
