require 'test_helper'

class EventRegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "creates an event registration for current user" do
    previous_count = users(:one).reload.events.count

    post event_event_registrations_path(events(:one)), headers: authorization_header_for(users(:one))

    assert_equal 204, response.status, response.status
    assert_equal(previous_count + 1, users(:one).reload.events.count)
  end

  test "lists event registrations for current user" do
    event_registration = users(:one).event_registrations.create! event: events(:one)

    get event_event_registrations_path(events(:one)), headers: authorization_header_for(users(:one))

    assert_equal 200, response.status, response.status
    assert_equal events(:one).id, JSON.parse(response.body)['events'][0]['id'], response.body
  end
end
