module Admin
  class AccessDeniedController < BaseController
    skip_before_action :require_admin!

    def show
    end
  end
end
