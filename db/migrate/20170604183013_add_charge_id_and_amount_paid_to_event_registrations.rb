class AddChargeIdAndAmountPaidToEventRegistrations < ActiveRecord::Migration[5.1]
  def change
    add_column :event_registrations, :charge_id, :string
    add_column :event_registrations, :amount_paid, :decimal, precision:8, scale:2
  end
end
