class ArticleSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :published_at

end
