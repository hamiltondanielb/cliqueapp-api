class AddPersonalLinkToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :personal_website, :string
  end
end
