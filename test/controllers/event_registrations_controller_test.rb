require 'test_helper'

class EventRegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "lists days with event registrations for seven weeks from date" do
    user = create :user

    create :event_registration, user:user, event: create(:event, start_time: 15.weeks.ago)
    create :event_registration, user:user, event: create(:event, start_time: 14.weeks.ago)
    create :event_registration, user:user, event: create(:event, start_time: 13.weeks.ago)
    create :event_registration, user:user, event: create(:event, start_time: 12.weeks.ago)
    create :event_registration, user:user, event: create(:event, start_time: 11.weeks.ago)
    create :event_registration, user:user, event: create(:event, start_time: 10.weeks.ago)
    create :event_registration, user:user, event: create(:event, start_time: 9.weeks.ago)
    create :event_registration, user:user, event: create(:event, start_time: 8.weeks.ago)
    create :event_registration, user:user, event: create(:event, start_time: 7.weeks.ago)

    get days_with_event_registrations_path, params: {seven_weeks_from: (14.weeks.ago - 1.day).iso8601}, headers: authorization_header_for(user)

    assert_equal 200, response.status, response.status
    assert_equal 7, JSON.parse(response.body)['days'].length, response.body
  end

  test "prevents cancelling an event registration if event is happening soon" do
    charge = PaymentProcessor.new.charge 100, "cus_AlqetMhwaNl8lg"
    user = create :user
    event = build :event, price: 100, start_time:6.hours.from_now
    event_registration = user.event_registrations.create! event: event, charge_id: charge.id, amount_paid: event.price

    delete event_registration_path(event), headers: authorization_header_for(user)

    assert_equal 200, response.status, response.status
    assert_json_contains_errors response.body, :global
    event_registration.reload
    refute event_registration.cancelled?
    refute event_registration.refunded?
    refute event_registration.refund_id.present?
  end

  test "cancels event registration for paid event" do
    charge = PaymentProcessor.new.charge 100, "cus_AlqetMhwaNl8lg"
    user = create :user
    event = build :event, price: 100
    event_registration = user.event_registrations.create! event: event, charge_id: charge.id, amount_paid: event.price

    delete event_registration_path(event), headers: authorization_header_for(user)

    assert_equal 204, response.status, response.status
    event_registration.reload
    assert event_registration.cancelled?
    assert event_registration.refunded?
    assert event_registration.refund_id.present?
  end

  test "handles errors from Stripe when cancelling an event" do
    charge = PaymentProcessor.new.charge 100, "cus_AlqetMhwaNl8lg"
    user = create :user
    event = build :event, price: 100
    event_registration = user.event_registrations.create! event: event, charge_id: "test", amount_paid: event.price

    delete event_registration_path(event), headers: authorization_header_for(user)

    assert_equal 200, response.status, response.status
    assert_json_contains_errors response.body, :global
    event_registration.reload
    refute event_registration.cancelled?
    refute event_registration.refunded?
    refute event_registration.refund_id.present?
  end

  test "creates an event registration for a paid event" do
    user = create :user
    event = create :event, price: 200

    post event_event_registrations_path(event), params: {stripe_info: {email: user.email, id: "tok_ca"}}, headers: authorization_header_for(user)

    assert_equal 204, response.status, "#{response.status}: #{response.body}"
    assert_equal 1, user.reload.events.count
  end

  test "it handles errors from Stripe when creating an event registration for a paid event" do
    user = create :user
    event = create :event, price: 200

    post event_event_registrations_path(event), params: {stripe_info: {email: user.email, id: "tok_test"}}, headers: authorization_header_for(user)

    assert_equal 200, response.status, "#{response.status}: #{response.body}"
    assert_json_contains_errors response.body, "global"
    assert_equal 0, user.reload.events.count
  end

  test "creates an event registration for a free event" do
    user = create :user
    event = create :event

    post event_event_registrations_path(event), params: {stripe_info: {email: user.email, id: "tok_ca"}}, headers: authorization_header_for(user)

    assert_equal 204, response.status, "#{response.status}: #{response.body}"
    assert_equal 1, user.reload.events.count
  end

  test "lists event registrations for that date for current user" do
    user = create :user
    event = create :event, start_time: 1.day.from_now
    user.event_registrations.create! event: event
    user.event_registrations.create! event: create(:event, start_time: 3.days.ago), cancelled_at: Time.now
    user.event_registrations.create! event: create(:event, start_time: 2.days.ago)

    get event_registrations_path, params: {date: 1.day.from_now.iso8601}, headers: authorization_header_for(user)

    assert_equal 200, response.status, response.status
    json = JSON.parse(response.body)
    assert_equal 1, json['posts'].length, response.body
    assert_equal event.post.id, json['posts'][0]['id'], response.body
  end

  test "cancels free event registration for current user" do
    user = create :user
    event = create :event, price:0
    event_registration = user.event_registrations.create! event: event

    delete event_registration_path(event), headers: authorization_header_for(user)

    assert_equal 204, response.status, response.status
    assert event_registration.reload.cancelled?
  end
end
