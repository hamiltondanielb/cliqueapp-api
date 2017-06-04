class AddCancelledAtToEventRegistrations < ActiveRecord::Migration[5.1]
  def change
    add_column :event_registrations, :cancelled_at, :datetime
  end
end
