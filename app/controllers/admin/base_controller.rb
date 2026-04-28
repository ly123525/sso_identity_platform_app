module Admin
  class BaseController < ApplicationController
    before_action :authenticate_user!
    before_action :require_active_user!
    before_action :require_admin!

    layout 'admin'

    private

    def require_active_user!
      return if current_user.active?

      sign_out current_user
      redirect_to new_user_session_path, alert: t('admin.flash.account_disabled')
    end

    def require_admin!
      return if current_user.admin?

      redirect_to admin_access_denied_path, alert: t('admin.flash.not_authorized')
    end
  end
end
