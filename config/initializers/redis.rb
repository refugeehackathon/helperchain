Sidekiq.redis = { url: ENV['REDIS_URL'], namespace: ENV["SIDEKIQ_NAMESPACE"] || 'sidekiq' }
