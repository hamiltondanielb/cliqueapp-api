class EventSerializer < ActiveModel::Serializer
  attributes :id, :start_time, :end_time, :difficulty_level, :price, :women_only

end
