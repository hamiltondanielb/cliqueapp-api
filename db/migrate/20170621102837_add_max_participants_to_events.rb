class AddMaxParticipantsToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :max_participants, :integer
  end
end
