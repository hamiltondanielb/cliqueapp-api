class Location < ApplicationRecord
  belongs_to :event

  validates :label, presence:true
end
