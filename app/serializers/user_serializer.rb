class UserSerializer < ActiveModel::Serializer

  attributes :id, :email, :created_at, :name, :profile_picture_url, :personal_website, :bio, :follow_count, :follower_count, :follows, :likes

  def profile_picture_url
    object.profile_picture.url(:medium)
  end

  def follows
    object.follows.map(&:followed_id)
  end

  def likes
    object.likes.map(&:post_id)
  end
end
