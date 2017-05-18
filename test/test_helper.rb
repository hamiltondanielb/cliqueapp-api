require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def authorization_header_for user
    payload = Warden::JWTAuth::PayloadUserHelper.payload_for_user(user, :user)
    {'Authorization' => "Bearer #{JWT.encode payload, ENV['DEVISE_JWT_SECRET_KEY'], 'HS256'}"}
  end
end
