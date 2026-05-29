class ApplicationController < ActionController::Base
  # Pundit is used as the shared authorization entry point for HTML and API controllers.
  # 全站统一从这里接入 Pundit，HTML 和 API 控制器都走同一套授权入口。
  include Pundit::Authorization

  # Keep locale selection centralized so the whole app, including Devise pages, stays consistent.
  # 语言切换逻辑集中放在这里，确保普通页面和 Devise 页面表现一致。
  before_action :set_locale

  private

  def set_locale
    # Locale priority is request param, then session, then app default.
    # 语言优先级依次是请求参数、session、应用默认值。
    locale = params[:locale].presence || session[:locale].presence || I18n.default_locale.to_s
    locale = I18n.default_locale.to_s unless I18n.available_locales.map(&:to_s).include?(locale)

    I18n.locale = locale
    session[:locale] = locale
  end

  def default_url_options
    # Avoid adding the locale param to default-locale URLs to keep routes cleaner.
    # 默认语言不追加 locale 参数，避免 URL 里出现冗余查询参数。
    I18n.locale == I18n.default_locale ? {} : { locale: I18n.locale }
  end
end
