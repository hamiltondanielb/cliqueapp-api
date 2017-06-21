class SetAgreedToPolicyOnAllEventRegistrations < ActiveRecord::Migration[5.1]
  def change
    EventRegistration.update_all agreed_to_policy:true
  end
end
