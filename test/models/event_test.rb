require 'test_helper'

class EventTest < ActiveSupport::TestCase
  test "counts the number of guests ignoring cancellations" do
    event = create :event
    create :event_registration, event: event
    create :event_registration, event: event, cancelled_at:Time.now

    assert_equal 1, event.guest_count
  end
end
