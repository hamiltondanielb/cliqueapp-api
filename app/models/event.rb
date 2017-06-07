class Event < ApplicationRecord
  belongs_to :post
  has_one :location, dependent: :destroy, autosave:true
  has_many :event_registrations, dependent: :destroy
  has_many :guests, through: :event_registrations, source: :user

  validates :start_time, :end_time, presence:true
  validate :only_instructors_can_create_events

  def guest_count
    active_event_registrations.count
  end

  def active_event_registrations
    event_registrations.where(cancelled_at:nil)
  end

  def active_guests
    User.joins(:event_registrations)
      .where('event_registrations.event_id':id)
      .where('event_registrations.cancelled_at':nil)
  end

  def free?
    return true if price.nil?

    !(price > 0)
  end

  protected
  def only_instructors_can_create_events
    if !post.user.instructor_terms_accepted?
      self.errors.add :base, "You must become an instructor before creating events."
    end
  end
end
