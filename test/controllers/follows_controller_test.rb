require 'test_helper'

class FollowsControllerTest < ActionDispatch::IntegrationTest
  test "lists followers for a user" do
    user1 = create :user
    user2 = create :user
    Follow.create! follower: user1, followed: user2

    get followers_path(user2)

    assert_equal 200, response.status
    assert response.body.include?(user1.name), response.body
  end

  test "lists following for a user" do
    user1 = create :user
    user2 = create :user
    Follow.create! follower: user1, followed: user2

    get following_path(user1)

    assert_equal 200, response.status
    assert response.body.include?(user2.name), response.body
  end

  test "creates a follow for current user" do
    user1 = create :user
    user2 = create :user

    post follows_path, params: {follow: {followed_id:user2.id}}, headers: authorization_header_for(user1)

    assert_equal 204, response.status
    assert_equal 1, user1.reload.following_count
  end

  test "destroys a follow" do
    user1 = create :user
    user2 = create :user
    follow = Follow.create! follower: user1, followed: user2

    delete destroy_follow_path(follow.followed_id), headers: authorization_header_for(user1)

    assert_equal 0, user1.reload.following_count
  end
end
