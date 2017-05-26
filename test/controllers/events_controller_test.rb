require 'test_helper'

class EventsControllerTest < ActionDispatch::IntegrationTest
  test "lists the events for current user for a certain date" do
    start_time_string = events(:one).start_time.iso8601

    get events_path, params: {date: start_time_string}, headers: authorization_header_for(events(:one).post.user)

    assert_equal 200, response.status
    assert response.body.include?(events(:one).id.to_s)
  end

  test "returns nothing if event search is empty" do
    get events_path, params: {date: "1990-05-27T06:25:58Z", user_id: users(:one).id}

    assert_equal 200, response.status
    assert_equal "{\"posts\":[]}", response.body
  end

  test "returns nothing if current user has no events" do
    start_time_string = events(:one).start_time.iso8601

    get events_path, params: {date: start_time_string}, headers: authorization_header_for(users(:two))

    assert_equal 200, response.status
    assert_equal "{\"posts\":[]}", response.body
  end

  test "returns events for another user" do
    start_time_string = events(:one).start_time.iso8601

    get events_path, params: {date: start_time_string, user_id:events(:one).post.user.id}

    assert_equal 200, response.status
    assert response.body.include?(events(:one).id.to_s)
  end
end
