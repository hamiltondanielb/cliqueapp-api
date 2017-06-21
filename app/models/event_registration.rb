class EventRegistration < ApplicationRecord
  belongs_to :user
  belongs_to :event
  validates :agreed_to_policy, inclusion: {in: [true]}

  scope :active, -> {where(cancelled_at:nil)}

  def self.unnotified_cancellations
    EventRegistration.where(cancellation_notified_at:nil).joins(:event).where('events.cancelled_at is not null')
  end

  def self.perform_refunds! currency: "JPY"
    errors = []

    event_registrations = to_be_refunded

    event_registrations.each do |e|
      begin
        e.refund! currency:currency
      rescue
        Rails.logger.error("Could not refund event registration id##{e.id}: #{$!} -- #{$!.backtrace}")
        errors << $!
      end
    end

    raise "There were #{errors.length} error(s) performing payouts" if errors.any?

    event_registrations
  end

  def self.to_be_refunded
    EventRegistration.where.not(charge_id:nil)
      .where(refunded_at:nil)
      .joins(:event).where('events.cancelled_at is not null')
  end

  def self.notify_of_cancellations!
    unnotified_cancellations.each do |event_registration|
      UserMailer.notify_of_cancellation(event_registration).deliver_now
      event_registration.update! cancellation_notified_at:Time.now
    end
  end

  def refund! currency:"JPY"
    refund = PaymentProcessor.new.refund self.charge_id, currency:currency
    self.update! refund_id:refund.id, refunded_at:Time.now
  end

  def incurred_charge?
    charge_id.present?
  end

  def paying_cash?
    !event.free? && !incurred_charge?
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
