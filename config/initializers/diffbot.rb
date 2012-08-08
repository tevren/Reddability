APP_CONFIG = YAML.load_file("#{Rails.root}/config/app_config.yml")[Rails.env]

Diffbot.configure do |config|
  config.token = APP_CONFIG["DIFFBOT_TOKEN"]
  config.instrumentor = ActiveSupport::Notifications
end
