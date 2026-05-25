module Api
  module V1
    class BaseController < ApplicationController
      # API controllers share the same error envelope instead of rendering Rails HTML pages.
      include HandlesApiErrors

      # API clients do not submit the browser CSRF token, so session-backed requests use a null session.
      protect_from_forgery with: :null_session
    end
  end
end