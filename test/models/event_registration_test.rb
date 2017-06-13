require 'test_helper'

class EventRegistrationTest < ActiveSupport::TestCase
  test "lists event registrations where we need to notify users of cancellation" do
    cancelled = create :event, price:100, start_time: 3.days.ago, cancelled_at:1.day.ago
    happening = create :event, price:100, start_time: 3.days.ago

    cancelled_registration = create :event_registration, event:cancelled, cancellation_notified_at:nil
    create :event_registration, event:cancelled, cancellation_notified_at:Time.now
    create :event_registration, event:happening

    assert_equal [cancelled_registration], EventRegistration.unnotified_cancellations
  end

  test "sends cancellation notifications" do
    cancelled = create :event, price:100, start_time: 3.days.ago, cancelled_at:1.day.ago
    cancelled_registration = create :event_registration, event:cancelled, cancellation_notified_at:nil

    EventRegistration.notify_of_cancellations!

    assert cancelled_registration.reload.cancellation_notified_at.present?
  end

  test "lists event registrations to be refunded" do
    cancelled = create :event, price:100, start_time: 3.days.ago, cancelled_at:1.day.ago
    happening = create :event, price:100, start_time: 3.days.ago

    to_be_refunded = create :event_registration, event:cancelled, refunded_at:nil, charge_id:"test"
    create :event_registration, event:cancelled, refunded_at:Time.now
    create :event_registration, event:happening

    assert_equal [to_be_refunded], EventRegistration.to_be_refunded
  end

  test "performs refunds" do
    event = create :event, price:100, start_time: 3.days.ago, cancelled_at:2.days.ago
    event.post.user.update! stripe_account_id: "acct_1APr3BLdGggRtZJo"
    charge = PaymentProcessor.new.charge 100, "cus_AlqetMhwaNl8lg"
    event_registration = create :event_registration, event:event, amount_paid:100, charge_id:charge.id

    EventRegistration.perform_refunds!

    event_registration.reload
    assert event_registration.refunded?
    assert event_registration.refund_id
  end

  test "handles error if refund fails" do
    event = create :event, price:100, start_time: 3.days.ago
    event.post.user.update! stripe_account_id: "acct_test"
    event_registration = create :event_registration, event:event, amount_paid:100

    assert_raises {event_registration.refund!}

    refute event_registration.refunded?
    refute event_registration.refund_id
  end
end
