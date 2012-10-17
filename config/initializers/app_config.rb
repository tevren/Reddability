if File.exists?("#{Rails.root}/config/app_config.yml")
	APP_CONFIG = YAML.load_file("#{Rails.root}/config/app_config.yml")[Rails.env]
end

