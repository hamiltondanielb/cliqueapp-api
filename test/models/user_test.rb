require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "destroy posts, events, locations, event registrations, and likes" do
    user = create :user
    post = create :post, user:user
    event = create :event, post:post
    location = create :location, event:event
    like = create :like, user:user, post:post
    event_registration = create :event_registration, event:event, user:user

    user.organized_events.destroy_all
    user.destroy!

    refute Post.find_by(id:post.id)
    refute Event.find_by(id:event.id)
    refute Location.find_by(id:location.id)
    refute EventRegistration.find_by(id:event_registration.id)
    refute Like.find_by(id:like.id)
  end

  test "includes own posts in home feed" do
    user = create :user
    post = create :post, user:user

    assert_equal [post], user.home_feed
  end

  test "does not include cancelled events in event count" do
    user = create :user
    post = create :post, user:user
    event = create :event, post:post

    assert_equal 1, user.reload.event_count

    event.update! cancelled_at:Time.now

    assert_equal 0, user.reload.event_count
  end
end
