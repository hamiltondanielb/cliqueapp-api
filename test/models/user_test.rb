require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "does not include cancelled events in event count" do
    user = create :user
    post = create :post, user:user
    event = create :event, post:post

    assert_equal 1, user.reload.event_count

    event.update! cancelled_at:Time.now

    assert_equal 0, user.reload.event_count
  end
end
