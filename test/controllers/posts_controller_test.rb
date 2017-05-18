require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  test "creates a post" do
    params = posts(:one).attributes
    params[:id] = nil
    params[:title] = "test post"
    params[:tag_list] = "cats, animals"

    post posts_path, params: {post: params}, headers: authorization_header_for(users(:one))

    assert_equal 201, response.status, "body was #{response.body}"
    assert_equal Post.last.title, "test post"
    assert_equal Post.last.tags.map(&:name), ["cats", "animals"]
  end

  test "creates a post with an image" do
    params = posts(:one).attributes
    params[:id] = nil
    file = Rack::Test::UploadedFile.new(Rails.root.join("test/fixtures/abstract-user.png"), "image/png")
    params[:media] = file

    post posts_path, params: {post: params}, headers: authorization_header_for(users(:one))

    assert_equal 201, response.status, "body was #{response.body}"
    refute Post.last.media.blank?
  end

  test "creates a post with a video" do
    params = posts(:one).attributes
    params[:id] = nil
    file = Rack::Test::UploadedFile.new(Rails.root.join("test/fixtures/what-yoga-is-about.mkv"), "video/x-matroska")
    params[:media] = file

    post posts_path, params: {post: params}, headers: authorization_header_for(users(:one))

    assert_equal 201, response.status, "body was #{response.body}"
    refute Post.last.media.blank?
  end

  test "shows a post" do
    get post_path(posts(:one))

    assert response.successful?
  end

  test "shows a user's feed" do
    get posts_path(user_id: users(:one))

    assert response.successful?
    assert response.body.include?(posts(:one).title)
  end
end
