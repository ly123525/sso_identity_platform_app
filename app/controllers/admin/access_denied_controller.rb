module Admin
  class AccessDeniedController < BaseController
    # This page must stay reachable for signed-in non-admin users after authorization fails.
    skip_before_action :authorize_admin_area!

    def show
      # Intentionally empty: Rails renders the matching template.
    end
  end
end
