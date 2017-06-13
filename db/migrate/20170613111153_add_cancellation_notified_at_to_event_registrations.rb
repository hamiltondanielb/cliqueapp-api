class AddCancellationNotifiedAtToEventRegistrations < ActiveRecord::Migration[5.1]
  def change
    add_column :event_registrations, :cancellation_notified_at, :datetime
  end
end
