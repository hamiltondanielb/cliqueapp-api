require 'test_helper'

class PostTest < ActiveSupport::TestCase
  test "it transcodes a MOV file to an MP4 with same audio and video tracks" do
    post = create :post
    file = Rack::Test::UploadedFile.new(Rails.root.join("test/fixtures/files/IMG_2746.MOV"), "video/quicktime")
    post.update! media:file

    assert post.media.styles.include?(:mp4)
  end

  test "it serializes all video formats" do
    post = create :post
    file = Rack::Test::UploadedFile.new(Rails.root.join("test/fixtures/files/IMG_2746.MOV"), "video/quicktime")
    post.update! media:file

    json = ActiveModelSerializers::SerializableResource.new(post).as_json

    assert_equal 2, json[:mediaList].length
    assert_equal 'video/quicktime', json[:mediaList][0][:contentType]
    assert_equal 'video/mp4', json[:mediaList][1][:contentType]
  end

  test "cleans and separates tag list" do
    post = create :post
    post.tag_list = ["cats , #dogs"]

    post.prepare_tag_list
    post.save!

    assert_equal ["cats", "dogs"], post.tags.map(&:name)
  end
end
