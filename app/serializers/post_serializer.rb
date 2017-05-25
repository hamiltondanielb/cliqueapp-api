class PostSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :description, :is_image, :is_video, :user_avatar_url, :user_name, :tag_list, :like_count, :user_id, :media_list, :event

  def media_list
    [{
      url: object.media.url(:original),
      content_type: object.media.content_type
    }].concat(object.media.styles.reject{|k| k == :thumb}.map{|k,v|
      {
        url: object.media.url(k),
        content_type: MimeMagic.by_extension(k).to_s
      }
    })

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

  def tag_list
    object.tags.map(&:name)
  end

  def event
    ActiveModelSerializers::SerializableResource.new object.event
  end
end
