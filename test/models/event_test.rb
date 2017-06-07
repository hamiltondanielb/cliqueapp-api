require 'test_helper'

class EventTest < ActiveSupport::TestCase
  test "prevents regular user from creating an event" do
    user = create :user, instructor_terms_accepted:false
    post = create :post, user:user
    event = build :event, post:post

    refute event.save

    user.update! instructor_terms_accepted:true

    assert event.save
  end

  test "counts the number of guests ignoring cancellations" do
    event = create :event
    create :event_registration, event: event
    create :event_registration, event: event, cancelled_at:Time.now

    assert_equal 1, event.guest_count
  end

  test "lists active guests ignoring cancellations" do
    event = create :event
    event_registration = create :event_registration, event: event
    create :event_registration, event: event, cancelled_at:Time.now

    assert_equal [event_registration.user], event.active_guests
  end
end
