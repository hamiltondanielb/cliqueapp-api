class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :created_at, :description, :media_url, :is_image, :is_video

  def media_url
    object.media.url(:medium)
  end

  def is_image
    object.is_image?
  end

  def is_video
    object.is_video?
  end
end
