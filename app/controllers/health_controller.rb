class HealthController < ApplicationController
  def show
    # The non-versioned endpoint is convenient for load balancers and simple uptime checks.
    render json: {
      status: 'ok',
      service: 'sso_identity_platform_app'
    }
  end
end