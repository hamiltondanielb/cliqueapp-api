require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "it updates the profile picture" do
    assert users(:one).profile_picture.blank?

    file = Rack::Test::UploadedFile.new(Rails.root.join("test/fixtures/abstract-user.png"), "image/png")
    patch user_path(users(:one)), xhr:true, params: {user: {profile_picture: file}}, headers: authorization_header_for(users(:one))

    assert response.successful?, "Response code was #{response.status} and body: #{response.body}"
    refute users(:one).reload.profile_picture.blank?
  end

  test "it connects a user with their stripe account" do
    mock_stripe_oauth_token

    assert users(:one).stripe_account_id.blank?

    post connect_stripe_path, params: {user: {authorization_code: "code"}}, headers: authorization_header_for(users(:one))

    assert_equal 204, response.status, response.status
    assert users(:one).reload.stripe_account_id.present?
  end

end
