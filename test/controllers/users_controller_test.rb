require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "it updates the profile picture" do
    assert users(:one).profile_picture.blank?

    file = Rack::Test::UploadedFile.new(Rails.root.join("test/fixtures/abstract-user.png"), "image/png")
    patch user_path(users(:one)), xhr:true, params: {user: {profile_picture: file}}, headers: authorization_header_for(users(:one))

    assert response.successful?, "Response code was #{response.status} and body: #{response.body}"
    refute users(:one).reload.profile_picture.blank?
  end

  def authorization_header_for user
    payload = Warden::JWTAuth::PayloadUserHelper.payload_for_user(user, :user)
    {'Authorization' => "Bearer #{JWT.encode payload, ENV['DEVISE_JWT_SECRET_KEY'], 'HS256'}"}
  end
end
