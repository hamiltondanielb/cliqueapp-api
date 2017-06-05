class EventRegistration < ApplicationRecord
  belongs_to :user
  belongs_to :event

  scope :active, -> {where(cancelled_at:nil)}

  def incurred_charge?
    charge_id.present?
  end

  def refunded?
    refunded_at.present?
  end

  def cancelled?
    cancelled_at.present?
  end

  def active?
    !cancelled?
  end

  def cancellable?
    event.start_time > 24.hours.from_now
  end
end
