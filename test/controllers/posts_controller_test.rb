require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  test "it doesn't allow users who have not accepted the instructor terms to create an event" do
    user = create(:user, instructor_terms_accepted:false)
    post = build :post
    params = post.attributes
    params[:media] = Rack::Test::UploadedFile.new(Rails.root.join("test/fixtures/files/abstract-user.png"), "image/png")
    params[:event] = {
      start_time: "2017-05-25T16:43:50.206Z",
      end_time: "2017-05-25T17:53:50.206Z",
      price: 100
    }

    post posts_path, params: {post: params}, headers: authorization_header_for(user)

    assert_equal 200, response.status, "#{response.status}: #{response.body[0,120]}"
    assert JSON.parse(response.body).include?('errors')
    assert response.body.include?('become an instructor before')
  end

  test "updates an event attached to a post" do
    event = create :event

    patch post_path(event.post), params: {post: {event: {
      start_time: "2017-05-25T16:43:50.206Z",
      end_time: "2017-05-25T17:53:50.206Z",
      cards_accepted: true,
      location: {
        label: 'Studio',
        address: '1 Shibuya',
        lat: 33.1,
        lng: 123.1
      }
    }}}, headers: authorization_header_for(event.post.user)

    assert_equal 200, response.status
    event.reload
    assert_equal 25, event.start_time.day
    assert_equal 17, event.end_time.hour
    assert_equal 53, event.end_time.min
    assert_equal 'Studio', event.location.label
    assert_equal '1 Shibuya', event.location.address
    assert_equal 33.1, event.location.lat
    assert_equal 123.1, event.location.lng
    assert event.cards_accepted?
  end

  test "creates a post attached to an event" do
    post = build :post
    params = post.attributes
    params[:media] = Rack::Test::UploadedFile.new(Rails.root.join("test/fixtures/files/abstract-user.png"), "image/png")
    params[:event] = {
      start_time: "2017-05-25T16:43:50.206Z",
      end_time: "2017-05-25T17:53:50.206Z"
    }
    params[:event][:location] = {
      label: 'Studio',
      address: '1 Shibuya',
      lat: 33.1,
      lng: 123.1
    }

    post posts_path, params: {post: params}, headers: authorization_header_for(create :user)

    assert_equal 201, response.status, "#{response.status}: #{response.body[0,120]}"
    assert Post.last.event.present?
    assert Post.last.event.location.present?
    assert_equal 25, Post.last.event.start_time.day
    assert_equal 17, Post.last.event.end_time.hour
    assert_equal 'Studio', Post.last.event.location.label
    assert_equal '1 Shibuya', Post.last.event.location.address
    assert_equal 33.1, Post.last.event.location.lat
    assert_equal 123.1, Post.last.event.location.lng
  end

  test "serves every post" do
    post = create :post

    get posts_path

    json = JSON.parse(response.body)
    assert_equal [post.id], json['posts'].map{|h|h["id"]}
    assert_equal 1, json["page"]
    assert_equal 1, json["total"]
  end

  test "serves user feed" do
    post = create :post

    get posts_path, params: {user_id: post.user.id}

    assert response.successful?, response.status
    assert_equal [post.id], JSON.parse(response.body)['posts'].map{|h|h["id"]}
  end

  test "deletes a post" do
    post = create :post
    delete post_path(post), headers: authorization_header_for(post.user)

    assert_equal 204, response.status, response.status
    refute Post.find_by(id: post.id), "post should have been deleted"
  end

  test "updates a post" do
    post = create :post
    patch post_path(post), params: {post: {description: "new description"}}, headers: authorization_header_for(post.user)

    assert response.successful?, response.body
    assert_equal "new description", post.reload.description, "body was #{response.body}"
  end

  test "creates a post with an image" do
    post = build :post
    params = post.attributes
    params[:id] = nil
    params[:description] = "test post"
    params[:tag_list] = "cats, animals"
    file = Rack::Test::UploadedFile.new(Rails.root.join("test/fixtures/files/abstract-user.png"), "image/png")
    params[:media] = file

    post posts_path, params: {post: params}, headers: authorization_header_for(post.user)

    assert_equal 201, response.status, "status was #{response.status}"
    assert_equal Post.last.description, "test post"
    assert_equal Post.last.tags.map(&:name), ["cats", "animals"]
    refute Post.last.media.blank?
  end

  test "shows a post" do
    post = create :post

    get post_path(post)

    assert response.successful?
  end
end
