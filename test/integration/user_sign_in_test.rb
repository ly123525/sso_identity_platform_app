require "test_helper"

class UserSignInTest < ActionDispatch::IntegrationTest
  test "disabled user cannot sign in" do
    post user_session_path, params: {
      user: {
        email: users(:disabled_admin).email,
        password: "password123"
      }
    }

    assert_redirected_to new_user_session_path
    follow_redirect!

    assert_includes response.body, "Your account has been disabled."
  end
end
