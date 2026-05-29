module Api
  module V1
    class HealthController < BaseController
      def show
        # 返回尽量精简，让探针只依赖进程是否可用。
        # Keep the payload small so probes only depend on process availability.
        render json: {
          status: 'ok',
          service: 'sso_identity_platform_app'
        }
      end
    end
  end
end