module Api
  module V1
    class BaseController < ApplicationController
      # API controllers share the same error envelope instead of rendering Rails HTML pages.
      # API 控制器统一返回 JSON 错误结构，不走 Rails 默认 HTML 异常页。
      include HandlesApiErrors

      # API clients do not submit the browser CSRF token, so session-backed requests use a null session.
      # API 客户端通常不会提交浏览器 CSRF token，这里改成空 session 以避免直接抛异常。
      protect_from_forgery with: :null_session
    end
  end
end