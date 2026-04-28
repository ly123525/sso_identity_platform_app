module Admin
  class DashboardController < BaseController
    def index
      @users_count = User.count
      @admins_count = User.admin.count
      @active_users_count = User.active.count
    end
  end
end
