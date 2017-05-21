require 'test_helper'

class FollowsControllerTest < ActionDispatch::IntegrationTest
  test "creates a follow for current user" do
    post follows_path, params: {follow: {followed_id:users(:two).id}}, headers: authorization_header_for(users(:one))

    assert_equal 204, response.status
    assert_equal 1, users(:one).reload.follow_count
  end

  test "destroys a follow" do
    follow = Follow.create! follower: users(:one), followed: users(:two)

    delete destroy_follow_path(follow.followed_id), headers: authorization_header_for(users(:one))

    assert_equal 0, users(:one).reload.follow_count
  end
end
