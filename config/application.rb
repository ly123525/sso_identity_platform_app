require_relative "boot"

require "logger"
require "rails/all"

# 按当前环境加载 Gemfile 中声明的依赖。
# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SsoIdentityPlatformApp
  class Application < Rails::Application
    # 使用 Rails 6.1 的默认配置基线。
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1
    config.i18n.available_locales = [:en, :'zh-CN']
    config.i18n.default_locale = :en
    # 在中间件层接入 Rack::Attack，让限流尽早生效。
    config.middleware.use Rack::Attack

    # 其它应用级配置写在这里，环境差异配置放在 config/environments 下覆盖。
    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
