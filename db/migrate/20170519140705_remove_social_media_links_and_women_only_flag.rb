class RemoveSocialMediaLinksAndWomenOnlyFlag < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :twitter_url, :string
    remove_column :users, :instagram_url, :string
    remove_column :users, :facebook_url, :string
    remove_column :posts, :women_only, :string
    remove_column :posts, :difficulty_level, :integer
    remove_column :posts, :title, :string
  end
end
