module Admin
  class AccessDeniedController < BaseController
    # This page must stay reachable for signed-in non-admin users after authorization fails.
    # 非管理员在授权失败后仍然要能进入这个页面，所以这里跳过后台权限检查。
    skip_before_action :authorize_admin_area!

    def show
      # Intentionally empty: Rails renders the matching template.
      # 无需额外逻辑，直接渲染同名模板即可。
    end
  end
end
