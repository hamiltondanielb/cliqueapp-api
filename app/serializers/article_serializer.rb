class ArticleSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :published_at, :user, :draft

  def draft
    object.draft?
  end

  def user
    ActiveModelSerializers::SerializableResource.new object.user
  end
end
