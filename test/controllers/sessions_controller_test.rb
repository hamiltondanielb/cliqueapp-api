require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "user signs in" do
    post user_session_path, xhr:true, params: {user: {email: users(:one).email, password: '12345678'}}

    assert response.successful?, response.body
    json = JSON.parse(response.body)
    assert_equal users(:one).email, json['email'], "json was #{json}"
    assert response.headers['Authorization'].include?('Bearer'), "headers were #{response.headers}"
  end

  test "user signs out" do
    old_jti = users(:one).jti

    post user_session_path, xhr:true, params: {user: {email: users(:one).email, password: '12345678'}}

    assert response.successful?, response.body

    token = response.headers['Authorization'].split(' ')[1]

    delete destroy_user_session_path, xhr:true, headers: {'Authorization' => "Bearer #{token}"}

    assert response.successful?
    assert users(:one).reload.jti != old_jti, "jti should have changed after signing out"
  end

end
