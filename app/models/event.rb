class Event < ApplicationRecord
  belongs_to :post
  has_one :location, dependent: :destroy, autosave:true
  has_many :event_registrations, dependent: :destroy
  has_many :guests, through: :event_registrations, source: :user

  validates :start_time, :end_time, presence:true
  validate :only_instructors_can_create_paid_events

  def guest_count
    event_registrations.count
  end

  def free?
    return true if price.nil?

    !(price > 0)
  end

  protected
  def only_instructors_can_create_paid_events
    if !free? && !post.user.instructor_terms_accepted?
      self.errors.add :base, "You must become an instructor before charging for your events."
    end
  end
end
