# Searchkick configuration
Searchkick.client_options = {
  url: ENV['ELASTICSEARCH_URL'] || 'http://localhost:9200',
  retry_on_failure: true,
  reload_connections: true,
  transport_options: {
    request: {
      timeout: 30,
      open_timeout: 30
    }
  }
}

# Configure index name prefix for different environments
Searchkick.index_prefix = "recruitment_app_#{Rails.env}"

# Configure search timeout
Searchkick.search_timeout = 30 
