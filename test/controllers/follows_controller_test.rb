require 'test_helper'

class FollowsControllerTest < ActionDispatch::IntegrationTest
  test "lists followers for a user" do
    Follow.create! follower: users(:one), followed: users(:two)

    get followers_path(users(:two))

    assert_equal 200, response.status
    assert response.body.include?(users(:one).name), response.body
  end

  test "lists following for a user" do
    Follow.create! follower: users(:one), followed: users(:two)

    get following_path(users(:one))

    assert_equal 200, response.status
    assert response.body.include?(users(:two).name), response.body
  end

  test "creates a follow for current user" do
    post follows_path, params: {follow: {followed_id:users(:two).id}}, headers: authorization_header_for(users(:one))

    assert_equal 204, response.status
    assert_equal 1, users(:one).reload.following_count
  end

  test "destroys a follow" do
    follow = Follow.create! follower: users(:one), followed: users(:two)

    delete destroy_follow_path(follow.followed_id), headers: authorization_header_for(users(:one))

    assert_equal 0, users(:one).reload.following_count
  end
end
