REDIS_OPTIONS = {
  host: Rails.env == 'production' ? 'redis' : 'localhost',
  port: '6379'
  #password: ENV['REDIS_PASSWORD']
}


Sidekiq.configure_client do |config|
  config.redis = REDIS_OPTIONS
end

Sidekiq.configure_server do |config|
  config.redis = REDIS_OPTIONS
end
