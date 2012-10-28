if File.exists?("#{Rails.root}/config/app_config.yml")
	APP_CONFIG = YAML.load_file("#{Rails.root}/config/app_config.yml")[Rails.env]
	GA.tracker = APP_CONFIG['GOOGLE_TOKEN'] if !APP_CONFIG['GOOGLE_TOKEN'].blank?
end

