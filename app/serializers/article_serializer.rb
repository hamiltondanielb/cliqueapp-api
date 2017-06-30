class ArticleSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :published_at, :user_id, :user

  def user
    ActiveModelSerializers::SerializableResource.new object.user
  end
end
