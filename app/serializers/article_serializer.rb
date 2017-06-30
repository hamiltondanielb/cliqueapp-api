class ArticleSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :published_at, :user_id

end
