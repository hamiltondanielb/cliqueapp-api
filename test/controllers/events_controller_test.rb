require 'test_helper'

class EventsControllerTest < ActionDispatch::IntegrationTest
  test "lists days with activity for seven weeks from date" do
    create_event(users(:one), 15.weeks.ago)
    create_event(users(:one), 14.weeks.ago)
    create_event(users(:one), 13.weeks.ago)
    create_event(users(:one), 12.weeks.ago)
    create_event(users(:one), 11.weeks.ago)
    create_event(users(:one), 10.weeks.ago)
    create_event(users(:one), 9.weeks.ago)
    create_event(users(:one), 8.weeks.ago)
    create_event(users(:one), 7.weeks.ago)

    get days_with_activity_path, params: {user_id: users(:one).id, seven_weeks_from: (14.weeks.ago - 1.day).iso8601}

    assert_equal 200, response.status, response.status
    assert_equal 7, JSON.parse(response.body)['days'].length, response.body
  end

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

  def create_event user, start_time
    media_attributes = {media_file_name: 'test.png', media_content_type: 'image/png', media_file_size: 1024}
    Event.create!(start_time: start_time, end_time: start_time + 1.hour, post: Post.create!(media_attributes.merge(user: user)))
  end
end
