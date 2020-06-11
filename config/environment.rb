# Load the Rails application.
require_relative 'application'

APP_CONFIG = YAML.load_file("#{Rails.root}/config/app_config.yml")[Rails.env]
# Initialize the Rails application.
Rails.application.initialize!

