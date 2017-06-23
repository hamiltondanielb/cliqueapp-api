require 'test_helper'

class EventTest < ActiveSupport::TestCase

  test "performs payouts" do
    event = create :event, price:100, start_time: 3.days.ago
    event.post.user.update! stripe_account_id: "acct_1APr3BLdGggRtZJo"
    create :event_registration, event:event, amount_paid:100

    Event.perform_payouts! currency:"EUR"

    event.reload
    assert event.paid_out?
    assert event.payout_id
    assert event.payout_currency
    assert event.payout_sum
  end

  test "handles error if paying out fails" do
    event = create :event, price:100, start_time: 3.days.ago
    event.post.user.update! stripe_account_id: "acct_test"
    create :event_registration, event:event, amount_paid:100

    assert_raises {event.pay_out!}

    refute event.paid_out?
    refute event.payout_id
  end

  test "calculates total paid by signer-ups" do
    event = create :event, price:100, start_time: 3.days.ago

    create :event_registration, event:event, amount_paid:50
    create :event_registration, event:event, amount_paid:100

    assert_equal 150, event.total_paid
  end

  test "lists events to be paid out" do
    event = create :event, price:100, start_time: 3.days.ago
    create :event, price:100, start_time: 3.days.ago, cancelled_at:1.day.ago
    create :event, price:100, start_time: 23.hours.ago
    create :event, price:100, start_time: 1.day.from_now
    create :event, price:0, start_time: 6.days.ago
    create :event, price:100, start_time: 6.days.ago, paid_out_at:4.days.ago

    assert_equal [event], Event.to_be_paid_out
  end

  test "prevents regular user from creating an event" do
    user = create :user, instructor_terms_accepted:false
    post = create :post, user:user
    event = build :event, post:post

    refute event.save

    user.update! instructor_terms_accepted:true

    assert event.save
  end

  test "counts the number of guests ignoring cancellations" do
    event = create :event
    create :event_registration, event: event
    create :event_registration, event: event, cancelled_at:Time.now

    assert_equal 1, event.guest_count
  end

  test "lists active guests ignoring cancellations" do
    event = create :event
    event_registration = create :event_registration, event: event
    create :event_registration, event: event, cancelled_at:Time.now

    assert_equal [event_registration.user], event.active_guests
  end
end
