class Rack::Attack
  self.enabled = true

  # Health checks should remain cheap and never get blocked by the authentication throttles.
  safelist('allow health checks') do |request|
    request.get? && ["/health", "/api/v1/health"].include?(request.path)
  end

  # Limit repeated password guesses from the same IP across HTML and API login endpoints.
  throttle('sign-in/ip', limit: 5, period: 20.seconds) do |request|
    request.ip if request.post? && ["/users/sign_in", "/api/v1/auth/login"].include?(request.path)
  end

  # Password reset is also security-sensitive, so it gets its own throttle window.
  throttle('password-reset/ip', limit: 5, period: 60.seconds) do |request|
    request.ip if request.post? && ["/users/password", "/api/v1/password_resets"].include?(request.path)
  end

  self.throttled_response = lambda do |env|
    request = ActionDispatch::Request.new(env)

    # API callers expect JSON; browser endpoints can use a plain text fallback for now.
    if request.path.start_with?('/api/')
      [
        429,
        { 'Content-Type' => 'application/json' },
        [{ error: { code: 'rate_limited', message: 'Too many requests.' } }.to_json]
      ]
    else
      [
        429,
        { 'Content-Type' => 'text/plain' },
        ['Too many requests.']
      ]
    end
  end
end

# MemoryStore is enough for local development and test; production can switch to Redis later.
Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new