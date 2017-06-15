class Follow < ApplicationRecord
  belongs_to :follower, class_name: 'User'
  belongs_to :followed, class_name: 'User'

  validates :follower_id, uniqueness: {scope: :followed_id}
  validate :users_cannot_follow_themselves

  private
  def users_cannot_follow_themselves
    if follower_id == followed_id || follower == followed
      self.errors.add :followed, "You cannot follow yourself."
    end
  end
end
