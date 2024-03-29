require 'simplecov'
SimpleCov.start unless ENV['NO_COVERAGE']
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'stripe_oauth_mock'
require 'payment_processor_mock'

class ActiveSupport::TestCase
  # Ignoring fixtures as we prefer using FactoryGirl
  # fixtures :all

  include FactoryGirl::Syntax::Methods

  # Add more helper methods to be used by all tests here...
  def authorization_header_for user
    payload = Warden::JWTAuth::PayloadUserHelper.payload_for_user(user, :user)
    {'Authorization' => "Bearer #{JWT.encode payload, ENV['DEVISE_JWT_SECRET_KEY'], 'HS256'}"}
  end

  def assert_json_contains_errors string, field=nil
    json = JSON.parse(string)
    assert json.has_key?("errors"), "The JSON string did not contain errors"
    if field.present?
      assert json["errors"].has_key?(field.to_s), "The JSON string contained errors but not for the specified field: #{field}. The JSON was #{json}"
    end
  end
end
