class Event < ApplicationRecord
  DAYS_BETWEEN_EVENT_AND_PAYOUT = 1

  belongs_to :post
  has_one :location, dependent: :destroy, autosave:true
  has_many :event_registrations, dependent: :destroy
  has_many :guests, through: :event_registrations, source: :user

  validates :start_time, :end_time, presence:true
  validate :only_instructors_can_create_events

  scope :active, -> {where(cancelled_at:nil)}

  def self.within_24_hours_of range_start
    range_end = range_start + 24.hours

    where('start_time >= ?', range_start).where('start_time <= ?', range_end)
  end

  def self.within_seven_weeks_from range_start
    range_end = range_start + 7.weeks

    where('start_time >= ?', range_start).where('start_time <= ?', range_end)
  end

  def self.perform_payouts! currency:"JPY"
    errors = []

    events = to_be_paid_out

    events.each do |e|
      begin
        e.pay_out! currency:currency
        UserMailer.inform_of_payout(e).deliver_now
      rescue
        Rails.logger.error("Could not pay out event id##{e.id}: #{$!} -- #{$!.backtrace}")
        errors << $!
      end
    end

    raise "There were #{errors.length} error(s) performing payouts" if errors.any?

    events
  end

  def self.to_be_paid_out
    Event.where(paid_out_at:nil)
      .where(cancelled_at:nil)
      .where('price is not null and price > 0')
      .where('start_time < ?', DAYS_BETWEEN_EVENT_AND_PAYOUT.days.ago)
  end

  def pay_out! currency:"JPY"
    payout = PaymentProcessor.new.pay_out total_paid, post.user.stripe_account_id, currency:currency
    self.update! paid_out_at: Time.now, payout_id: payout.id, payout_sum: payout.amount, payout_currency: payout.currency
  end

  def total_paid
    active_event_registrations.map(&:amount_paid).compact.sum
  end

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

  def cancelled?
    cancelled_at.present?
  end

  def paid_out?
    paid_out_at.present?
  end

  protected
  def only_instructors_can_create_events
    if !post.user.instructor_terms_accepted?
      self.errors.add :base, "You must become an instructor before creating events."
    end
  end
end
