require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "defaults to user role and active status" do
    user = User.new(email: "user@example.com", password: "password123")

    assert_equal "user", user.role
    assert_equal "active", user.status
  end

  test "can be an admin" do
    user = User.new(email: "admin@example.com", password: "password123", role: "admin")

    assert user.admin?
  end

  test "does not include self registration devise module" do
    assert_not User.devise_modules.include?(:registerable)
  end
end
