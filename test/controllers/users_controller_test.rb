require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "it updates the profile picture" do
    user = create :user, profile_picture:nil

    file = Rack::Test::UploadedFile.new(Rails.root.join("test/fixtures/files/abstract-user.png"), "image/png")
    patch user_path(user), xhr:true, params: {user: {profile_picture: file}}, headers: authorization_header_for(user)

    assert response.successful?, "Response code was #{response.status} and body: #{response.body}"
    refute user.reload.profile_picture.blank?
  end

  test "it connects a user with their stripe account" do
    mock_stripe_oauth_token
    user = create :user, stripe_account_id:nil

    post connect_stripe_path, params: {user: {authorization_code: "code"}}, headers: authorization_header_for(user)

    assert_equal 204, response.status, response.status
    assert user.reload.stripe_account_id.present?
  end

end
