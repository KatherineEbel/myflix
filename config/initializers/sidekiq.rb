REDIS_URL = ENV['REDIS_PROVIDER'] || Rails
  .application
  .credentials
  .dig(:redis).dig(:url)

Sidekiq.configure_server do |config|
  config.redis = { url: REDIS_URL }
end

Sidekiq.configure_client do |config|
  config.redis = { url: REDIS_URL }
end
