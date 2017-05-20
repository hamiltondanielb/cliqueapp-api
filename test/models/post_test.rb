require 'test_helper'

class PostTest < ActiveSupport::TestCase
  test "cleans and separates tag list" do
    post = posts(:one)
    post.tag_list = ["cats , #dogs"]

    post.prepare_tag_list
    post.save!

    assert_equal ["cats", "dogs"], post.tags.map(&:name)
  end
end
