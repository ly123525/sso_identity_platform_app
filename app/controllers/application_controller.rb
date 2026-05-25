class ApplicationController < ActionController::Base
  # Pundit is used as the shared authorization entry point for HTML and API controllers.
  include Pundit::Authorization

  # Keep locale selection centralized so the whole app, including Devise pages, stays consistent.
  before_action :set_locale

  private

  def set_locale
    # Locale priority is request param, then session, then app default.
    locale = params[:locale].presence || session[:locale].presence || I18n.default_locale.to_s
    locale = I18n.default_locale.to_s unless I18n.available_locales.map(&:to_s).include?(locale)

    I18n.locale = locale
    session[:locale] = locale
  end

  def default_url_options
    # Avoid adding the locale param to default-locale URLs to keep routes cleaner.
    I18n.locale == I18n.default_locale ? {} : { locale: I18n.locale }
  end
end
