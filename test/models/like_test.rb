require 'test_helper'

class LikeTest < ActiveSupport::TestCase
  test "creates only one like for each user to each post" do
    Like.create! user:users(:one), post:posts(:one)

    like = Like.new user:users(:one), post:posts(:one)

    refute like.save
  end

  test "calculates like count" do
    assert_equal 0, posts(:one).like_count

    Like.create! user:users(:one), post:posts(:one)

    assert_equal 1, posts(:one).reload.like_count
  end
end
