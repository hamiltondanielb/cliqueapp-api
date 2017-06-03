class AddInstructorTermsAcceptedToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :instructor_terms_accepted, :boolean, default:false
  end
end
