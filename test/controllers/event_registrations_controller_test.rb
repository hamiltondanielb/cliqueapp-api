require 'test_helper'

class EventRegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "prevents cancelling an event registration if event is happening soon" do
    charge = PaymentProcessor.new.charge 100, "cus_AlqetMhwaNl8lg"
    user = create :user
    event = build :event, price: 100, start_time:6.hours.from_now
    event_registration = user.event_registrations.create! event: event, charge_id: charge.id, amount_paid: event.price

    delete event_registration_path(event), headers: authorization_header_for(user)

    assert_equal 200, response.status, response.status
    assert_json_contains_errors response.body, :base
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

  test "creates an event registration for a free event" do
    user = create :user
    event = create :event

    post event_event_registrations_path(event), params: {stripe_info: {email: user.email, id: "tok_ca"}}, headers: authorization_header_for(user)

    assert_equal 204, response.status, "#{response.status}: #{response.body}"
    assert_equal 1, user.reload.events.count
  end

  test "lists active event registrations for current user" do
    user = create :user
    event = create :event
    user.event_registrations.create! event: event
    user.event_registrations.create! event: create(:event), cancelled_at: Time.now

    get event_registrations_path, headers: authorization_header_for(user)

    assert_equal 200, response.status, response.status
    assert_equal event.id, JSON.parse(response.body)['events'][0]['id'], response.body
    assert_equal 1, JSON.parse(response.body)['events'].length, response.body
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
