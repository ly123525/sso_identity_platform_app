require "test_helper"

class LocaleSwitchingTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "admin pages can switch to Chinese" do
    sign_in users(:admin)

    get admin_root_path(locale: "zh-CN")

    assert_response :success
    assert_select "h1", text: "控制台"
    assert_select "a", text: "English"
    assert_select "a", text: "中文"
  end

  test "front layout includes language switcher" do
    get new_user_session_path(locale: "zh-CN")

    assert_response :success
    assert_select "h1", text: "登录"
    assert_select "a", text: "English"
    assert_select "a", text: "中文"
  end
end
