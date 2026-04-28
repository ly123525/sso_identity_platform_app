require "test_helper"

class Admin::UsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:admin)
  end

  test "lists users" do
    get admin_users_path

    assert_response :success
    assert_select "td", text: users(:admin).email
  end

  test "renders new user form" do
    get new_admin_user_path

    assert_response :success
    assert_select "form"
  end

  test "creates user" do
    assert_difference "User.count", 1 do
      post admin_users_path, params: {
        user: {
          email: "new-user@example.com",
          name: "New User",
          role: "user",
          status: "active",
          password: "password123",
          password_confirmation: "password123"
        }
      }
    end

    assert_redirected_to admin_users_path
  end

  test "renders edit user form" do
    get edit_admin_user_path(users(:user))

    assert_response :success
    assert_select "form"
    assert_select "input[name='user[password]']", count: 0
  end

  test "updates user" do
    patch admin_user_path(users(:user)), params: {
      user: {
        email: users(:user).email,
        name: "Updated User",
        role: "admin",
        status: "disabled",
        password: "ignored-password"
      }
    }

    assert_redirected_to admin_users_path

    users(:user).reload
    assert_equal "Updated User", users(:user).name
    assert_equal "admin", users(:user).role
    assert_equal "disabled", users(:user).status
  end

  test "renders reset password form" do
    get edit_password_admin_user_path(users(:user))

    assert_response :success
    assert_select "form"
    assert_select "input[name='user[password]']"
  end

  test "resets user password" do
    patch update_password_admin_user_path(users(:user)), params: {
      user: {
        password: "new-password123",
        password_confirmation: "new-password123"
      }
    }

    assert_redirected_to admin_users_path
    assert users(:user).reload.valid_password?("new-password123")
  end

  test "does not reset password when confirmation does not match" do
    patch update_password_admin_user_path(users(:user)), params: {
      user: {
        password: "new-password123",
        password_confirmation: "different-password"
      }
    }

    assert_response :unprocessable_entity
    assert_not users(:user).reload.valid_password?("new-password123")
  end
end
