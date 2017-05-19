class UserSerializer < ActiveModel::Serializer
  include ActionView::Helpers::AssetUrlHelper

  attributes :id, :email, :created_at, :name, :profile_picture_url, :personal_website, :bio

  def profile_picture_url
    object.profile_picture.url(:medium)
  end
end
