class User < ApplicationRecord
  # First phase keeps authentication minimal: password login plus password recovery.
  # 第一阶段先保持最小认证闭环，只启用密码登录和密码找回。
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable

  # Roles stay intentionally small for now; Pundit builds on top of this distinction.
  # 第一版只区分普通用户和管理员，后续权限判断基于这个枚举继续扩展。
  enum role: {
    user: 'user',
    admin: 'admin'
  }

  # Status is separate from role so an admin can still be disabled without changing privileges.
  # 账号状态和角色分离，方便保留管理员身份的同时单独禁用账号。
  enum status: {
    active: 'active',
    disabled: 'disabled'
  }

  validates :role, presence: true, inclusion: { in: roles.keys }
  validates :status, presence: true, inclusion: { in: statuses.keys }

  def active_for_authentication?
    # Devise calls this hook before sign-in and on authenticated requests.
    # Devise 会在登录前和已登录请求中调用这个钩子，禁用账号在这里统一拦住。
    super && active?
  end

  def inactive_message
    # Return a custom key so the UI can explain that access was blocked by account status.
    # 返回自定义文案 key，让界面能明确提示是“账号被禁用”而不是普通登录失败。
    active? ? super : :disabled
  end
end
