class AddPayoutCurrencyToEvent < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :payout_currency, :string
  end
end
