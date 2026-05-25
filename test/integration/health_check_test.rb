require "test_helper"

class HealthCheckTest < ActionDispatch::IntegrationTest
  test "returns ok from root health endpoint" do
    get "/health"

    assert_response :success
    assert_equal(
      {
        "status" => "ok",
        "service" => "sso_identity_platform_app"
      },
      JSON.parse(response.body)
    )
  end

  test "returns ok from api v1 health endpoint" do
    get "/api/v1/health"

    assert_response :success
    assert_equal(
      {
        "status" => "ok",
        "service" => "sso_identity_platform_app"
      },
      JSON.parse(response.body)
    )
  end
end