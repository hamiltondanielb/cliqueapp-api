require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  test "updates an event attached to a post" do
    event = events(:one)

    patch post_path(event.post), params: {post: {event: {
      start_time: "2017-05-25T16:43:50.206Z",
      end_time: "2017-05-25T17:53:50.206Z"
    }}}, headers: authorization_header_for(event.post.user)

    assert_equal 200, response.status
    assert_equal 25, event.reload.start_time.day
    assert_equal 17, event.reload.end_time.hour
    assert_equal 53, event.reload.end_time.min
  end

  test "creates a post attached to an event" do
    params = posts(:one).attributes
    params[:media] = Rack::Test::UploadedFile.new(Rails.root.join("test/fixtures/IMG_2746.MOV"), "video/quicktime")
    params[:event] = {
      start_time: "2017-05-25T16:43:50.206Z",
      end_time: "2017-05-25T17:53:50.206Z"
    }

    post posts_path, params: {post: params}, headers: authorization_header_for(users(:one))

    assert_equal 201, response.status, response.status
    assert Post.last.event.present?
    assert_equal 25, Post.last.event.start_time.day
    assert_equal 17, Post.last.event.end_time.hour
  end

  test "serves feed from follows" do
    users(:one).follows.create! followed_id: users(:two).id

    get posts_path, headers: authorization_header_for(users(:one))

    assert_equal users(:one).home_feed.map{|h|h["id"]}, JSON.parse(response.body).map{|h|h["id"]}
  end

  test "serves user feed" do
    get posts_path, params: {user_id: users(:one).id}

    assert response.successful?, response.status
    assert users(:one).posts.any?
    assert_equal users(:one).posts.map{|h|h["id"]}, JSON.parse(response.body).map{|h|h["id"]}
  end

  test "deletes a post" do
    delete post_path(posts(:one)), headers: authorization_header_for(posts(:one).user)

    assert_equal 204, response.status, response.status
    refute Post.find_by(id: posts(:one).id), "post should have been deleted"
  end

  test "updates a post" do
    patch post_path(posts(:one)), params: {post: {description: "new description"}}, headers: authorization_header_for(posts(:one).user)

    assert response.successful?, response.body
    assert_equal "new description", posts(:one).reload.description, "body was #{response.body}"
  end

  test "creates a post with an image" do
    params = posts(:one).attributes
    params[:id] = nil
    params[:description] = "test post"
    params[:tag_list] = "cats, animals"
    file = Rack::Test::UploadedFile.new(Rails.root.join("test/fixtures/abstract-user.png"), "image/png")
    params[:media] = file

    post posts_path, params: {post: params}, headers: authorization_header_for(users(:one))

    assert_equal 201, response.status, "status was #{response.status}"
    assert_equal Post.last.description, "test post"
    assert_equal Post.last.tags.map(&:name), ["cats", "animals"]
    refute Post.last.media.blank?
  end

  test "creates a post with a video" do
    params = posts(:one).attributes
    params[:id] = nil
    file = Rack::Test::UploadedFile.new(Rails.root.join("test/fixtures/IMG_2746.MOV"), "video/quicktime")
    params[:media] = file

    post posts_path, params: {post: params}, headers: authorization_header_for(users(:one))

    assert_equal 201, response.status, "status was #{response.status}"
    refute Post.last.media.blank?
  end

  test "shows a post" do
    get post_path(posts(:one))

    assert response.successful?
  end

  test "shows a user's feed" do
    get posts_path(user_id: users(:one))

    assert response.successful?
    assert response.body.include?(posts(:one).description)
  end
end
