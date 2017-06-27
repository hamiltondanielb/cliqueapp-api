require 'test_helper'

class ConfirmationsControllerTest < ActionDispatch::IntegrationTest

  test "user confirms" do
    new_user = User.create! email: 'tobeconfirmed@example.org', name: 'tester', password:'12345678'
    get user_confirmation_path, params: {confirmation_token: new_user.confirmation_token}

    assert response.successful?, "body was #{response.body}"
    assert new_user.reload.confirmed?
  end

  test "user asks to resend instructions" do
    new_user = User.create! email: 'tobeconfirmed@example.org', name: 'tester', password:'12345678', confirmation_sent_at:nil
    
    post user_confirmation_path, headers: authorization_header_for(new_user)

    assert response.successful?, "body was #{response.body}"
    assert new_user.reload.confirmation_sent_at, "confirmation_sent_at should have been set"
  end

end
