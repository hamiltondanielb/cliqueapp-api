class UserSerializer < ActiveModel::Serializer
  attributes :email, :created_at, :name
end
