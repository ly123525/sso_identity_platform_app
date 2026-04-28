module Admin
  class BaseController < ApplicationController
    before_action :authenticate_user!
    before_action :require_admin!

    layout 'admin'

    private

    def require_admin!
      return if current_user.admin?

      redirect_to admin_access_denied_path, alert: 'You are not authorized to access the admin area.'
    end
  end
end
