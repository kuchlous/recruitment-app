# Set default URL options for link_to and url_for helpers
Rails.application.configure do
  config.action_controller.default_url_options = { host: APP_CONFIG['host_name'] }
  config.action_mailer.default_url_options = { host: APP_CONFIG['host_name'] }
end 