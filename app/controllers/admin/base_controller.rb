module Admin
  class BaseController < ApplicationController
    # Admin screens always require an authenticated session first.
    # 管理端所有页面都必须先具备登录态。
    before_action :authenticate_user!
    # Disabled users should not keep access even if they still have a valid session cookie.
    # 即使 session 还有效，禁用账号也不能继续访问管理端。
    before_action :require_active_user!
    # Pundit remains the single authorization gate for all admin controllers.
    # 管理端统一通过 Pundit 做权限入口控制，避免各控制器重复写角色判断。
    before_action :authorize_admin_area!

    # HTML admin screens redirect to the access denied page instead of returning JSON errors.
    # 管理端是 HTML 页面，未授权时跳转到统一拒绝访问页而不是返回 JSON。
    rescue_from Pundit::NotAuthorizedError, with: :redirect_access_denied

    layout 'admin'

    private

    def require_active_user!
      return if current_user.active?

      # Force logout so a disabled account cannot continue navigating the admin area.
      # 账号被禁用后强制登出，避免用户带着旧会话继续浏览后台。
      sign_out current_user
      redirect_to new_user_session_path, alert: t('admin.flash.account_disabled')
    end

    def authorize_admin_area!
      # The symbolic :admin record keeps the policy focused on area-level access.
      # 这里用符号对象做区域级授权，不把权限判断绑死在某个具体模型上。
      authorize :admin, :access?
    end

    def redirect_access_denied
      # Reuse the shared access denied page so unauthorized admin requests behave consistently.
      # 统一走拒绝访问页，保证所有后台未授权请求的交互一致。
      redirect_to admin_access_denied_path, alert: t('admin.flash.not_authorized')
    end
  end
end
