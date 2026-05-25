require "test_helper"

class AdminPolicyTest < ActiveSupport::TestCase
  test "allows active admins" do
    assert AdminPolicy.new(users(:admin), :admin).access?
  end

  test "rejects regular users" do
    assert_not AdminPolicy.new(users(:user), :admin).access?
  end

  test "rejects disabled admins" do
    assert_not AdminPolicy.new(users(:disabled_admin), :admin).access?
  end
end