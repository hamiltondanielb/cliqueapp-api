require 'test_helper'

class LikesControllerTest < ActionDispatch::IntegrationTest
  test "creates a like for current user" do
    post likes_path, params: {like: {post_id:posts(:one).id}}, headers: authorization_header_for(users(:one))

    assert_equal 204, response.status, response.body
    assert_equal 1, posts(:one).reload.like_count
  end

  test "unlikes" do
    like = Like.create! user: users(:one), post: posts(:one)

    delete destroy_like_path(like.post_id), headers: authorization_header_for(users(:one))

    assert_response :success
    assert_equal 0, posts(:one).reload.like_count
  end
end
