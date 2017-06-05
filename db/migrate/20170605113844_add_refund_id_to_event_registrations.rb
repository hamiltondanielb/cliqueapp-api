class AddRefundIdToEventRegistrations < ActiveRecord::Migration[5.1]
  def change
    add_column :event_registrations, :refund_id, :string
  end
end
