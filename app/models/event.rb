class Event < ApplicationRecord
  belongs_to :post
  has_one :location, dependent: :destroy, autosave:true
  has_many :event_registrations, dependent: :destroy
  has_many :guests, through: :event_registrations, source: :user

  validates :start_time, :end_time, presence:true

  def guest_count
    event_registrations.count
  end

  def free?
    !(price > 0)
  end
end
