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
end
