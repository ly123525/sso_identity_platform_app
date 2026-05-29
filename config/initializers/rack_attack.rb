class Rack::Attack
  self.enabled = true

  # 健康检查必须保持可达，不能被认证相关限流误伤。
  # Health checks should remain cheap and never get blocked by the authentication throttles.
  safelist('allow health checks') do |request|
    request.get? && ["/health", "/api/v1/health"].include?(request.path)
  end

  # 对同一 IP 的重复登录尝试做限流，覆盖 HTML 和 API 登录入口。
  # Limit repeated password guesses from the same IP across HTML and API login endpoints.
  throttle('sign-in/ip', limit: 5, period: 20.seconds) do |request|
    request.ip if request.post? && ["/users/sign_in", "/api/v1/auth/login"].include?(request.path)
  end

  # 密码重置也是敏感入口，因此单独设置限流窗口。
  # Password reset is also security-sensitive, so it gets its own throttle window.
  throttle('password-reset/ip', limit: 5, period: 60.seconds) do |request|
    request.ip if request.post? && ["/users/password", "/api/v1/password_resets"].include?(request.path)
  end

  self.throttled_response = lambda do |env|
    request = ActionDispatch::Request.new(env)

    # API 调用方期望 JSON，浏览器页面先用纯文本兜底。
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

# 开发和测试环境先用内存缓存，生产环境后续可以切到 Redis。
# MemoryStore is enough for local development and test; production can switch to Redis later.
Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new