require 'test_helper'

class EventsControllerTest < ActionDispatch::IntegrationTest
  test "lists days with activity for seven weeks from date" do
    user = create :user
    create :event, post: create(:post, user:user), start_time: 15.weeks.ago
    create :event, post: create(:post, user:user), start_time: 14.weeks.ago
    create :event, post: create(:post, user:user), start_time: 13.weeks.ago
    create :event, post: create(:post, user:user), start_time: 12.weeks.ago
    create :event, post: create(:post, user:user), start_time: 11.weeks.ago
    create :event, post: create(:post, user:user), start_time: 10.weeks.ago
    create :event, post: create(:post, user:user), start_time: 9.weeks.ago
    create :event, post: create(:post, user:user), start_time: 8.weeks.ago
    create :event, post: create(:post, user:user), start_time: 7.weeks.ago

    get days_with_activity_path, params: {user_id: user.id, seven_weeks_from: (14.weeks.ago - 1.day).iso8601}

    assert_equal 200, response.status, response.status
    assert_equal 7, JSON.parse(response.body)['days'].length, response.body
  end

  test "lists the events for current user for a certain date" do
    event = create :event
    start_time_string = event.start_time.iso8601

    get events_path, params: {date: start_time_string}, headers: authorization_header_for(event.post.user)

    assert_equal 200, response.status
    assert response.body.include?(event.id.to_s)
  end

  test "returns nothing if event search is empty" do
    user = create :user
    get events_path, params: {date: "1990-05-27T06:25:58Z", user_id: user.id}

    assert_equal 200, response.status
    assert_equal "{\"posts\":[]}", response.body
  end

  test "returns nothing if current user has no events" do
    start_time_string = create(:event).start_time.iso8601

    get events_path, params: {date: start_time_string}, headers: authorization_header_for(create(:user))

    assert_equal 200, response.status
    assert_equal "{\"posts\":[]}", response.body
  end

  test "lists events for another user" do
    event = create :event
    start_time_string = event.start_time.iso8601

    get events_path, params: {date: start_time_string, user_id: event.post.user.id}

    assert_equal 200, response.status
    assert response.body.include?(event.id.to_s)
  end
end
