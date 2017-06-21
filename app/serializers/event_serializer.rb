class EventSerializer < ActiveModel::Serializer
  attributes :id, :start_time, :end_time, :difficulty_level, :price, :women_only, :location, :guest_count, :event_registrations, :cancelled, :cards_accepted, :max_participants

  def location
    ActiveModelSerializers::SerializableResource.new object.location
  end

  def event_registrations
    ActiveModelSerializers::SerializableResource.new object.event_registrations
  end

  def cancelled
    object.cancelled?
  end
end
