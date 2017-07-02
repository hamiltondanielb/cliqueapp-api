class Location < ApplicationRecord
  belongs_to :event

  validates :label, presence:true

  geocoded_by :address, :latitude  => :lat, :longitude => :lng 
  after_validation :geocode          # auto-fetch coordinates
end
