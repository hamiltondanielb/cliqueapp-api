require 'test_helper'

class ConfirmationsControllerTest < ActionDispatch::IntegrationTest

  test "user confirms" do
    new_user = User.create! email: 'tobeconfirmed@example.org', name: 'tester', password:'12345678'
    get user_confirmation_path, params: {confirmation_token: new_user.confirmation_token}

    assert response.successful?, "body was #{response.body}"
    assert new_user.reload.confirmed?
  end

  test "user asks to resend instructions" do
    new_user = User.create! email: 'tobeconfirmed@example.org', name: 'tester', password:'12345678'
    old_time = new_user.confirmation_sent_at
    post user_confirmation_path, params: {email: new_user.email}

    assert response.successful?, "body was #{response.body}"
    assert new_user.reload.confirmation_sent_at != old_time, "confirmation_sent_at should have been updated"
  end

end
