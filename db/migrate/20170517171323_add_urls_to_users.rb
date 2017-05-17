class AddUrlsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :facebook_url, :string
    add_column :users, :instagram_url, :string
    add_column :users, :twitter_url, :string
  end
end
