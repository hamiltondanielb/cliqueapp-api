class AddPayoutSumToEvent < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :payout_sum, :decimal, precision: 8, scale: 2
  end
end
