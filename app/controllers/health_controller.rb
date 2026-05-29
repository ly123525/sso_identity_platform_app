class HealthController < ApplicationController
  def show
    # The non-versioned endpoint is convenient for load balancers and simple uptime checks.
    # 非版本化健康检查接口便于负载均衡和基础存活探针直接调用。
    render json: {
      status: 'ok',
      service: 'sso_identity_platform_app'
    }
  end
end