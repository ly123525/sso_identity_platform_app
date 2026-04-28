require "test_helper"

class Admin::DashboardControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "redirects guest to sign in" do
    get admin_root_path

    assert_redirected_to new_user_session_path
  end

  test "allows admin" do
    sign_in users(:admin)

    get admin_root_path

    assert_response :success
  end

  test "rejects regular user" do
    sign_in users(:user)

    get admin_root_path

    assert_redirected_to admin_access_denied_path
    assert_equal "You are not authorized to access the admin area.", flash[:alert]
  end

  test "regular user can see access denied page" do
    sign_in users(:user)

    get admin_access_denied_path

    assert_response :success
    assert_select "h1", text: "Access denied"
  end

  test "disabled signed in user is signed out and redirected" do
    sign_in users(:disabled_admin)

    get admin_root_path

    assert_redirected_to new_user_session_path
    assert_equal "Your account has been disabled.", flash[:alert]
  end
end
