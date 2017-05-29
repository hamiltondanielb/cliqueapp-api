class EventSerializer < ActiveModel::Serializer
  attributes :id, :start_time, :end_time, :difficulty_level, :price, :women_only, :location, :guest_count, :guests

  def location
    ActiveModelSerializers::SerializableResource.new object.location
  end

end
