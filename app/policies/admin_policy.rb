class AdminPolicy < ApplicationPolicy
  def access?
    # Admin access requires both the admin role and an enabled account.
    user.present? && user.admin? && user.active?
  end
end