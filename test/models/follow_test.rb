require 'test_helper'

class FollowTest < ActiveSupport::TestCase
  test "creates only one follow" do
    users(:one).follows.create! followed:users(:two)

    duplicate = users(:one).follows.build followed:users(:two)
    refute duplicate.save
  end

  test "counts follows and followers" do
    assert_equal 0, users(:one).follow_count
    assert_equal 0, users(:two).follower_count

    users(:one).follows.create! followed:users(:two)

    assert_equal 1, users(:one).reload.follow_count
    assert_equal 1, users(:two).reload.follower_count
  end

end
