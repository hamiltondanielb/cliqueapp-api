require 'test_helper'

class EventRegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "cancels event registration for paid event" do
    charge = PaymentProcessor.new.charge 100, "cus_AlqetMhwaNl8lg"
    event_registration = users(:one).event_registrations.create! event: events(:two), charge_id: charge.id, amount_paid: 100

    delete event_registration_path(events(:two)), headers: authorization_header_for(users(:one))

    assert_equal 204, response.status, response.status
    assert event_registration.reload.cancelled?
    assert event_registration.reload.refunded?
  end

  test "processes a payment when registering to an event" do
    previous_count = users(:one).reload.events.count

    post event_event_registrations_path(events(:two)), params: {stripe_info: {email: users(:one).email, id: "tok_ca"}}, headers: authorization_header_for(users(:one))

    assert_equal 204, response.status, "#{response.status}: #{response.body}"
    assert_equal(previous_count + 1, users(:one).reload.events.count)
  end

  test "creates an event registration for a free event" do
    previous_count = users(:one).reload.events.count

    post event_event_registrations_path(events(:one)), headers: authorization_header_for(users(:one))

    assert_equal 204, response.status, response.status
    assert_equal(previous_count + 1, users(:one).reload.events.count)
  end

  test "lists active event registrations for current user" do
    users(:one).event_registrations.create! event: events(:one)

    get event_registrations_path, headers: authorization_header_for(users(:one))

    assert_equal 200, response.status, response.status
    assert_equal events(:one).id, JSON.parse(response.body)['events'][0]['id'], response.body
    assert_equal 1, JSON.parse(response.body)['events'].length, response.body
  end

  test "cancels free event registration for current user" do
    event_registration = users(:one).event_registrations.create! event: events(:one)

    delete event_registration_path(events(:one)), headers: authorization_header_for(users(:one))

    assert_equal 204, response.status, response.status
    assert event_registration.reload.cancelled?
  end
end
