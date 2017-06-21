class AddAgreedToPolicyToEventRegistrations < ActiveRecord::Migration[5.1]
  def change
    add_column :event_registrations, :agreed_to_policy, :boolean, default:false
  end
end
