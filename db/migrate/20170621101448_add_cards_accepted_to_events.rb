class AddCardsAcceptedToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :cards_accepted, :boolean, default:false
  end
end
