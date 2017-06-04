require 'test_helper'

class LikeTest < ActiveSupport::TestCase
  test "creates only one like for each user to each post" do
    user = create :user
    post = create :post
    Like.create! user:user, post:post

    like = Like.new user:user, post:post

    refute like.save
  end

  test "calculates like count" do
    post = create :post
    assert_equal 0, post.like_count

    Like.create! user:create(:user), post:post

    assert_equal 1, post.reload.like_count
  end
end
