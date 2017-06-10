class AddPaidOutToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :paid_out_at, :datetime
    add_column :events, :payout_id, :string
  end
end
