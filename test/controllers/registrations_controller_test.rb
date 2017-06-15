require 'test_helper'

class RegistrationsControllerTest < ActionDispatch::IntegrationTest

  test "user signs up" do
    post user_registration_path, params: {user: {email: 'test@example.org', password: '12345678', name: 'tester'}}

    assert response.successful?, "body was #{response.body}"
    assert response.headers['Authorization'].start_with?('Bearer')
    assert_equal 'tester', JSON.parse(response.body)['name'], response.body
  end
end
