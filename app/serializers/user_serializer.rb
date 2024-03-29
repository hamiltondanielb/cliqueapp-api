class UserSerializer < ActiveModel::Serializer

  attributes :id, :created_at, :name, :profile_picture_url, :personal_website, :bio, :following_count, :follower_count, :follows, :likes, :post_count, :event_count, :registered_for_payouts, :instructor_terms_accepted, :private, :confirmed

  def profile_picture_url
    object.profile_picture.url(:medium)
  end

  def registered_for_payouts
    object.stripe_account_id.present?
  end

  def follows
    object.follows.map(&:followed_id)
  end

  def likes
    object.likes.map(&:post_id)
  end

  def post_count
    object.posts.count
  end

  def confirmed
    object.confirmed_at.present?
  end
end
