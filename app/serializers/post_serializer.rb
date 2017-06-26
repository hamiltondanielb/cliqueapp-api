class PostSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :description, :is_image, :user_avatar_url, :tag_list, :like_count, :user_id, :media_list, :event, :user

  def media_list
    object.media.styles.keys.reduce({}) {|hash, style|
      hash[style] = {
        url: object.media.url(style),
        content_type: object.media.content_type
      }
      hash
    }
  end

  def user_avatar_url
    object.user.profile_picture.url(:thumb)
  end

  def user
    ActiveModelSerializers::SerializableResource.new object.user
  end

  def is_image
    object.is_image?
  end

  def tag_list
    object.tags.map(&:name)
  end

  def event
    ActiveModelSerializers::SerializableResource.new object.event
  end
end
