require 'test_helper'

class PostTest < ActiveSupport::TestCase
  test "does not include a post in public scope if user was deleted" do
    event = create :event

    assert_equal [event.post], Post.public

    event.post.user.destroy!

    assert_equal [], Post.public
  end

  test "it does not delete a post if it is linked to an event" do
    post = create :post, event: create(:event)

    refute post.destroy

    post.reload.update! event:nil

    assert post.destroy
  end

  test "cleans and separates tag list" do
    post = create :post
    post.tag_list = ["cats , #dogs"]

    post.prepare_tag_list
    post.save!

    assert_equal ["cats", "dogs"], post.tags.map(&:name)
  end
end
