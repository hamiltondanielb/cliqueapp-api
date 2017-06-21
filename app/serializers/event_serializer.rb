class EventSerializer < ActiveModel::Serializer
  attributes :id, :start_time, :end_time, :difficulty_level, :price, :women_only, :location, :guest_count, :guests, :cancelled, :cards_accepted

  def location
    ActiveModelSerializers::SerializableResource.new object.location
  end

  def guests
    object.active_guests
  end

  def cancelled
    object.cancelled?
  end
end
