class PostSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :description, :media_url, :is_image, :is_video, :user_avatar_url, :user_name, :content_type

  def media_url
    object.media.url(:original)
  end

  def user_avatar_url
    object.user.profile_picture.url(:thumb)
  end

  def user_name
    object.user.name
  end

  def is_image
    object.is_image?
  end

  def is_video
    object.is_video?
  end

  def content_type
    object.media.content_type
  end
end
