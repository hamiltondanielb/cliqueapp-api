require 'test_helper'

class PostTest < ActiveSupport::TestCase
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
