require 'test_helper'

class EventRegistrationsControllerTest < ActionDispatch::IntegrationTest
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

  test "lists event registrations for current user" do
    users(:one).event_registrations.create! event: events(:one)

    get event_registrations_path, headers: authorization_header_for(users(:one))

    assert_equal 200, response.status, response.status
    assert_equal events(:one).id, JSON.parse(response.body)['events'][0]['id'], response.body
  end

  test "cancels event registration for current user" do
    users(:one).event_registrations.create! event: events(:one)

    delete event_registration_path(events(:one)), headers: authorization_header_for(users(:one))

    assert_equal 204, response.status, response.status
    assert users(:one).reload.event_registrations.empty?
  end
end
