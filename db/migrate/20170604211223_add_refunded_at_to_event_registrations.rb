class AddRefundedAtToEventRegistrations < ActiveRecord::Migration[5.1]
  def change
    add_column :event_registrations, :refunded_at, :datetime
  end
end
