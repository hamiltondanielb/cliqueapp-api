class Event < ApplicationRecord
  belongs_to :post
  has_one :location, dependent: :destroy, autosave:true

  validates :start_time, :end_time, presence:true
end
