class AdminPolicy < ApplicationPolicy
  def access?
    # 进入后台同时要求管理员角色和启用状态。
    # Admin access requires both the admin role and an enabled account.
    user.present? && user.admin? && user.active?
  end
end