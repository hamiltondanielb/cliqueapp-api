require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  i_suck_and_my_tests_are_order_dependent! # seems to make the mocks less brittle

  teardown do
    StripeOAuthMock.unmock
    PaymentProcessorMock.unmock
  end

  test "it deletes a user account" do
    user = create :user
    post = create :post, user:user
    event = create :event, post: create(:post, user:user)
    like = create :like, post:post
    other = create :user
    follow1 = create :follow, follower:user, followed: other
    follow2 = create :follow, followed:user, follower: other

    delete user_path(user), headers: authorization_header_for(user)

    assert_equal 204, response.status
    refute User.find_by(id:user.id)
  end

  test "it prevents a normal user from retrieving a private user" do
    user = create :user, private:true

    get user_path(user)

    assert_equal 404, response.status

    user.update! private:false

    get user_path(user)

    assert_equal 200, response.status
  end

  test "it allows a current user to see their profile even if private" do
    user = create :user, private:true

    get user_path(user), headers: authorization_header_for(user)

    assert_equal 200, response.status
  end

  test "it handles errors when updating a user" do
    user = create :user, profile_picture:nil

    file = Rack::Test::UploadedFile.new(Rails.root.join("test/fixtures/files/abstract-user.png"), "something/else")
    patch user_path(user), xhr:true, params: {user: {profile_picture: file}}, headers: authorization_header_for(user)

    assert_equal 200, response.status, response.status
    assert_json_contains_errors response.body, "profile_picture"
  end

  test "it handles error from Stripe when connecting account" do
    user = create :user

    post connect_stripe_path, params: {user: {authorization_code: "ac_test"}}, headers: authorization_header_for(user)

    assert_equal 200, response.status, response.status
    assert_json_contains_errors response.body, "global"
  end

  test "it handles error from Stripe when disconnecting account" do
    user = create :user, stripe_account_id: "acct_test"

    post disconnect_stripe_path, headers: authorization_header_for(user)

    assert_equal 200, response.status, response.status
    assert_json_contains_errors response.body, "global"
  end

  test "it updates the profile picture" do
    user = create :user, profile_picture:nil

    file = Rack::Test::UploadedFile.new(Rails.root.join("test/fixtures/files/abstract-user.png"), "image/png")
    patch user_path(user), xhr:true, params: {user: {profile_picture: file}}, headers: authorization_header_for(user)

    assert response.successful?, "Response code was #{response.status} and body: #{response.body}"
    refute user.reload.profile_picture.blank?
  end

  test "it connects a user with their stripe account" do
    StripeOAuthMock.mock
    ActionMailer::Base.deliveries.clear

    user = create :user, stripe_account_id:nil

    post connect_stripe_path, params: {user: {authorization_code: "code"}}, headers: authorization_header_for(user)

    assert_equal 204, response.status, response.status
    assert user.reload.stripe_account_id.present?
    assert_equal 1, ActionMailer::Base.deliveries.length
  end

  test "it disconnects a user from their stripe account" do
    PaymentProcessorMock.mock
    StripeOAuthMock.mock

    user = create :user, stripe_account_id: "acct_test"

    post disconnect_stripe_path, headers: authorization_header_for(user)

    assert_equal 204, response.status, "#{response.status}: #{response.body}"
    refute user.reload.stripe_account_id
  end
end
