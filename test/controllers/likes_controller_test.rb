require 'test_helper'

class LikesControllerTest < ActionDispatch::IntegrationTest
  test "creates a like for current user" do
    post = create :post
    post likes_path, params: {like: {post_id:post.id}}, headers: authorization_header_for(create :user)

    assert_equal 204, response.status, response.body
    assert_equal 1, post.reload.like_count
  end

  test "unlikes" do
    post = create :post
    user = create :user
    like = Like.create! user: user, post: post

    delete destroy_like_path(like.post_id), headers: authorization_header_for(user)

    assert_response :success
    assert_equal 0, post.reload.like_count
  end
end
