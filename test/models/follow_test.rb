require 'test_helper'

class FollowTest < ActiveSupport::TestCase
  test "users cannot follow a private user" do
    user1 = create :user
    user2 = create :user, private: true
    follow = user1.follows.build followed:user2

    refute follow.save

    follow.followed = create(:user)

    assert follow.save
  end

  test "users cannot follow themselves" do
    user1 = create :user
    follow = user1.follows.build followed:user1

    refute follow.save

    follow.followed = create(:user)

    assert follow.save
  end

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
