class LocationSerializer < ActiveModel::Serializer
  attributes :id, :label, :address, :lat, :lng

end
