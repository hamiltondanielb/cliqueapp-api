require 'test_helper'

class FollowTest < ActiveSupport::TestCase
  test "creates only one follow" do
    user1 = create :user
    user2 = create :user
    user1.follows.create! followed:user2

    duplicate = user1.follows.build followed:user2
    refute duplicate.save
  end

  test "counts follows and followers" do
    user1 = create :user
    user2 = create :user

    user1.follows.create! followed:user2

    assert_equal 1, user1.reload.following_count
    assert_equal 1, user2.reload.follower_count
  end

end
