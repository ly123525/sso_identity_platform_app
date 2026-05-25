module Admin
  class BaseController < ApplicationController
    # Admin screens always require an authenticated session first.
    before_action :authenticate_user!
    # Disabled users should not keep access even if they still have a valid session cookie.
    before_action :require_active_user!
    # Pundit remains the single authorization gate for all admin controllers.
    before_action :authorize_admin_area!

    # HTML admin screens redirect to the access denied page instead of returning JSON errors.
    rescue_from Pundit::NotAuthorizedError, with: :redirect_access_denied

    layout 'admin'

    private

    def require_active_user!
      return if current_user.active?

      # Force logout so a disabled account cannot continue navigating the admin area.
      sign_out current_user
      redirect_to new_user_session_path, alert: t('admin.flash.account_disabled')
    end

    def authorize_admin_area!
      # The symbolic :admin record keeps the policy focused on area-level access.
      authorize :admin, :access?
    end

    def redirect_access_denied
      # Reuse the shared access denied page so unauthorized admin requests behave consistently.
      redirect_to admin_access_denied_path, alert: t('admin.flash.not_authorized')
    end
  end
end
